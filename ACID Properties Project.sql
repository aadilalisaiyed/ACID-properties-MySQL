CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(15)
);
CREATE TABLE Account (
    account_id INT PRIMARY KEY,
    customer_id INT,
    balance DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);
CREATE TABLE TransactionLog (
    txn_id INT PRIMARY KEY,
    account_id INT,
    amount DECIMAL(10,2),
    txn_type VARCHAR(50),
    txn_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Account(account_id)
);

INSERT INTO Customer (customer_id, name, phone) VALUES
(1, 'Aadil', '9876500011'), (2, 'Anish', '9876500022'), (3, 'Akshit', '9876500033'),
(4, 'Aditi', '9876500044'), (5, 'Aditya', '9876500055'), (6, 'Abhishek', '9876500066');
INSERT INTO Account (account_id, customer_id, balance) VALUES
(101, 1, 5000.00), (102, 2, 3200.00), (103, 3, 4500.00),
(104, 4, 8000.00), (105, 5, 1500.00), (106, 6, 9000.00);

-- Example: Transfer ₹1000 from Aadil (101) → Anish (102)
START TRANSACTION;

-- Step 1: Deduct from sender
UPDATE Account
SET balance = balance - 1000
WHERE account_id = 101;

-- Step 2: Credit receiver
UPDATE Account
SET balance = balance + 1000
WHERE account_id = 102;

-- Step 3: Log both operations
INSERT INTO TransactionLog (txn_id, account_id, amount, txn_type)
VALUES
(301, 101, -1000, 'TRANSFER_OUT'),
(302, 102,  1000, 'TRANSFER_IN');

-- If everything is correct:
COMMIT;

-- If any error happens:
-- ROLLBACK;
