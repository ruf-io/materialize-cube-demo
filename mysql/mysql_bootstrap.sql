CREATE DATABASE IF NOT EXISTS shop;
USE shop;

GRANT ALL PRIVILEGES ON shop.* TO 'mysqluser';

CREATE USER 'debezium' IDENTIFIED WITH mysql_native_password BY 'dbz';

GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium';

FLUSH PRIVILEGES;

CREATE TABLE IF NOT EXISTS shop.users
(
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    is_vip BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shop.vendors
(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shop.items
(
    id SERIAL PRIMARY KEY,
    vendor_id BIGINT UNSIGNED REFERENCES vendor(id),
    name VARCHAR(100),
    category VARCHAR(100),
    price DECIMAL(7,2),
    inventory INT,
    inventory_updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS shop.purchases
(
    id SERIAL PRIMARY KEY,
    user_id BIGINT UNSIGNED REFERENCES user(id),
    item_id BIGINT UNSIGNED REFERENCES item(id),
    status TINYINT UNSIGNED DEFAULT 1,
    quantity INT UNSIGNED DEFAULT 1,
    purchase_price DECIMAL(12,2),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
