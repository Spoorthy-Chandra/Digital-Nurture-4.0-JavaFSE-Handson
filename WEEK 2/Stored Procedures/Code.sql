--Create table accounts
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    account_holder VARCHAR2(100),
    account_type VARCHAR2(20),
    balance NUMBER(10,2)
);
INSERT INTO accounts (account_id,account_holder, account_type, balance) VALUES (123,'Alice', 'savings', 1000.00);
INSERT INTO accounts (account_id,account_holder, account_type, balance) VALUES (678,'Bob', 'current', 2000.00);
INSERT INTO accounts (account_id,account_holder, account_type, balance) VALUES (890,'Charlie', 'savings', 1500.00);
INSERT INTO accounts (account_id,account_holder, account_type, balance) VALUES (346,'Diana', 'savings', 2500.00);
SELECT * FROM accounts;

--Create table employees
CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    name VARCHAR2(100),
    department_id NUMBER,
    salary NUMBER(10,2)
);
INSERT INTO employees (employee_id, name, department_id, salary) VALUES (101, 'Alice', 1, 50000.00);
INSERT INTO employees (employee_id, name, department_id, salary) VALUES (102, 'Bob', 2, 60000.00);
INSERT INTO employees (employee_id, name, department_id, salary) VALUES (103, 'Charlie', 1, 55000.00);
INSERT INTO employees (employee_id, name, department_id, salary) VALUES (104, 'Diana', 3, 70000.00);
SELECT * FROM employees;


--Scenario 1:
CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
BEGIN
    UPDATE accounts
    SET balance = balance * 1.01
    WHERE account_type = 'savings';
END;
/
BEGIN
    ProcessMonthlyInterest;
END;
/
SELECT * FROM accounts;
SELECT * FROM accounts WHERE account_type = 'savings';


--Scenario 2:
CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    dept_id IN NUMBER,
    bonus_percent IN NUMBER
) IS
BEGIN
    UPDATE employees
    SET salary = salary + (salary * bonus_percent / 100)
    WHERE department_id = dept_id;
END;
/
BEGIN
    UpdateEmployeeBonus(1, 10);
END;
/
SELECT * FROM employees;
SELECT * FROM employees WHERE department_id = 1;


--Scenario 3:
CREATE OR REPLACE PROCEDURE TransferFunds (
    p_source_account_id IN NUMBER,
    p_target_account_id IN NUMBER,
    p_amount            IN NUMBER
) AS
    v_source_balance NUMBER;
BEGIN
    -- Step 1: Get source balance
    SELECT balance
    INTO v_source_balance
    FROM accounts
    WHERE account_id = p_source_account_id;

    DBMS_OUTPUT.PUT_LINE('Source account balance: ' || v_source_balance);

    -- Step 2: Check sufficient balance
    IF v_source_balance < p_amount THEN
        DBMS_OUTPUT.PUT_LINE('Insufficient balance. Cannot transfer.');
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient balance in source account.');
    END IF;

    -- Step 3: Deduct from source account
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_source_account_id;

    DBMS_OUTPUT.PUT_LINE('Deducted ' || p_amount || ' from account ' || p_source_account_id);

    -- Step 4: Add to target account
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_target_account_id;

    DBMS_OUTPUT.PUT_LINE('Added ' || p_amount || ' to account ' || p_target_account_id);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transfer completed successfully.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('One or both account IDs do not exist.');
        RAISE_APPLICATION_ERROR(-20002, 'Source or target account does not exist.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
        RAISE;
END;
/
SET SERVEROUTPUT ON;
BEGIN
    TransferFunds(123, 678, 200);
END;
/
SELECT account_id, account_holder, balance
FROM accounts
WHERE account_id IN (123, 678);











