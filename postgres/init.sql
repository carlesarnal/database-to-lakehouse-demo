-- Inventory database for CDC demo
-- Based on the Debezium example database

CREATE SCHEMA IF NOT EXISTS inventory;

CREATE TABLE inventory.customers (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE inventory.orders (
    order_number INTEGER PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INTEGER NOT NULL REFERENCES inventory.customers(id),
    quantity INTEGER NOT NULL,
    price NUMERIC(10,2) NOT NULL
);

INSERT INTO inventory.customers VALUES
    (1001, 'Sally', 'Thomas', 'sally.thomas@acme.com'),
    (1002, 'George', 'Bailey', 'gbailey@foobar.com'),
    (1003, 'Edward', 'Walker', 'ed@walker.com'),
    (1004, 'Anne', 'Kretchmar', 'annek@noanswer.org');

INSERT INTO inventory.orders VALUES
    (10001, '2024-01-16', 1001, 1, 102.50),
    (10002, '2024-01-17', 1002, 2, 56.25),
    (10003, '2024-02-19', 1002, 1, 199.99),
    (10004, '2024-02-21', 1003, 3, 45.00);

-- Create publication for Debezium logical replication
ALTER TABLE inventory.customers REPLICA IDENTITY FULL;
ALTER TABLE inventory.orders REPLICA IDENTITY FULL;
