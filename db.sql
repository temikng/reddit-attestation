CREATE TABLE reddit_users (
	reddit_user_id CHAR(32) NOT NULL PRIMARY KEY,
	reddit_name CHAR(255) NOT NULL,
	reddit_karma INTEGER NOT NULL,
	reddit_created TIMESTAMP NOT NULL,
	creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
	device_address CHAR(33) NOT NULL PRIMARY KEY,
	user_address CHAR(32) NULL,
	reddit_user_id CHAR(32) NULL,
	creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (device_address) REFERENCES correspondent_devices(device_address),
	FOREIGN KEY (reddit_user_id) REFERENCES reddit_users(reddit_user_id)
);

CREATE TABLE receiving_addresses (
	receiving_address CHAR(32) NOT NULL PRIMARY KEY,
	device_address CHAR(33) NOT NULL,
	user_address CHAR(32) NOT NULL,
	reddit_user_id INTEGER NOT NULL,
	creation_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	post_publicly TINYINT NULL,
	price INT NULL,
	last_price_date TIMESTAMP NULL,
	UNIQUE (device_address, user_address, reddit_user_id),
	FOREIGN KEY (device_address) REFERENCES correspondent_devices(device_address),
	FOREIGN KEY (reddit_user_id) REFERENCES reddit_users(reddit_user_id),
	FOREIGN KEY (receiving_address) REFERENCES my_addresses(address)
);
CREATE INDEX byReceivingAddress ON receiving_addresses(receiving_address);
CREATE INDEX byUserAddress ON receiving_addresses(user_address);


CREATE TABLE transactions (
	transaction_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	receiving_address CHAR(32) NOT NULL,
	price INT NOT NULL,
	received_amount INT NOT NULL,
	payment_unit CHAR(44) NOT NULL UNIQUE,
	payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	is_confirmed INT NOT NULL DEFAULT 0,
	confirmation_date TIMESTAMP NULL,
	FOREIGN KEY (receiving_address) REFERENCES receiving_addresses(receiving_address),
	FOREIGN KEY (payment_unit) REFERENCES units(unit) ON DELETE CASCADE
);


CREATE TABLE attestation_units (
	transaction_id INTEGER NOT NULL,
	attestation_unit CHAR(44) NULL UNIQUE,
	attestation_date TIMESTAMP NULL,
	PRIMARY KEY (transaction_id),
	FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
	FOREIGN KEY (attestation_unit) REFERENCES units(unit)
);

CREATE TABLE rejected_payments (
	rejected_payment_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	receiving_address CHAR(32) NOT NULL,
	price INT NOT NULL,
	received_amount INT NOT NULL,
	payment_unit CHAR(44) NOT NULL UNIQUE,
	payment_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	error TEXT NOT NULL,
	FOREIGN KEY (receiving_address) REFERENCES receiving_addresses(receiving_address),
	FOREIGN KEY (payment_unit) REFERENCES units(unit) ON DELETE CASCADE
);

CREATE TABLE reward_units (
	transaction_id INTEGER NOT NULL PRIMARY KEY,
	user_address CHAR(32) NOT NULL UNIQUE,
	reddit_user_id CHAR(32) NOT NULL UNIQUE,
	user_id CHAR(44) NOT NULL UNIQUE,
	reward INT NOT NULL,
	reward_unit CHAR(44) NULL UNIQUE,
	reward_date TIMESTAMP NULL,
	FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
	FOREIGN KEY (reward_unit) REFERENCES units(unit)
);

CREATE TABLE referral_reward_units (
	transaction_id INTEGER NOT NULL PRIMARY KEY,
	user_address CHAR(32) NOT NULL,
	reddit_user_id CHAR(32) NOT NULL UNIQUE,
	user_id CHAR(44) NOT NULL,
	new_user_id CHAR(44) NOT NULL UNIQUE,
	new_reddit_user_id CHAR(32) NOT NULL UNIQUE,
	new_user_address CHAR(44) NOT NULL UNIQUE,
	reward INT NOT NULL,
	reward_unit CHAR(44) NULL UNIQUE,
	reward_date TIMESTAMP NULL,
	FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
	FOREIGN KEY (new_user_id) REFERENCES reward_units(user_id),
	FOREIGN KEY (reward_unit) REFERENCES units(unit)
);
