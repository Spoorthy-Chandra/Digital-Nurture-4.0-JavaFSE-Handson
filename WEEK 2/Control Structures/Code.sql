--CREATE Customers Table
CREATE TABLE Customers (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(50),
    Age NUMBER,
    Balance NUMBER,
    IsVIP VARCHAR2(5) DEFAULT 'FALSE'
);

--CREATE Loans Table
CREATE TABLE Loans (
    LoanID NUMBER PRIMARY KEY,
    CustomerID NUMBER,
    InterestRate NUMBER(5,2),
    DueDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

--Insert customer details into Customers Table
INSERT INTO Customers VALUES (1, 'John Smith', 65, 15000, 'FALSE');
INSERT INTO Customers VALUES (2, 'Alice Brown', 45, 8000, 'FALSE');
INSERT INTO Customers VALUES (3, 'Michael Lee', 70, 12000, 'FALSE');
INSERT INTO Customers VALUES (4, 'Suresh Kumar', 62, 9500, 'FALSE');
INSERT INTO Customers VALUES (5, 'Meera Das', 68, 11000, 'FALSE');
INSERT INTO Customers VALUES (6, 'Rajiv Nair', 75, 30000, 'FALSE');
INSERT INTO Customers VALUES (7, 'Anita Sharma', 50, 10500, 'FALSE');
INSERT INTO Customers VALUES (8, 'Vikram Rao', 35, 4000, 'FALSE');
INSERT INTO Customers VALUES (9, 'Kiran Patil', 28, 16000, 'FALSE');
INSERT INTO Customers VALUES (10, 'Priya Sinha', 59, 10050, 'FALSE');

--Insert loan details into Loans Table
INSERT INTO Loans VALUES (101, 1, 7.5, TO_DATE('2025-07-10', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (102, 2, 6.0, TO_DATE('2025-08-15', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (103, 3, 8.0, TO_DATE('2025-06-30', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (104, 4, 7.0, TO_DATE('2025-07-01', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (105, 5, 6.8, TO_DATE('2025-07-25', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (106, 6, 7.9, TO_DATE('2025-07-15', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (107, 7, 6.5, TO_DATE('2025-08-20', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (108, 8, 6.3, TO_DATE('2025-07-10', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (109, 9, 6.0, TO_DATE('2025-06-29', 'YYYY-MM-DD'));
INSERT INTO Loans VALUES (110, 10, 6.9, TO_DATE('2025-07-30', 'YYYY-MM-DD'));
COMMIT;

--View Customers Table
SELECT * FROM Customers;

--View Loans Table
SELECT * FROM Loans;

--Scenario 1:
DECLARE
    CURSOR cur_customers IS
        SELECT CustomerID, InterestRate
        FROM Loans
        WHERE CustomerID IN (
            SELECT CustomerID
            FROM Customers
            WHERE Age > 60
        );
BEGIN
    FOR rec IN cur_customers LOOP
        UPDATE Loans
        SET InterestRate = InterestRate - 1
        WHERE CustomerID = rec.CustomerID;
    END LOOP;
    COMMIT;
END;
SELECT c.CustomerID, c.Name, c.Age, l.LoanID, l.InterestRate
FROM Customers c
JOIN Loans l ON c.CustomerID = l.CustomerID
WHERE c.Age > 60;

--Scenario 2:
BEGIN
    FOR rec IN (
        SELECT CustomerID
        FROM Customers
        WHERE Balance > 10000
    ) LOOP
        UPDATE Customers
        SET IsVIP = 'TRUE'
        WHERE CustomerID = rec.CustomerID;
    END LOOP;
    COMMIT;
END;
SELECT CustomerID, Name, Balance, IsVIP
FROM Customers
WHERE IsVIP = 'TRUE';

--Scenario 3:
DECLARE
    CURSOR cur_due_loans IS
        SELECT l.CustomerID, l.DueDate, c.Name
        FROM Loans l
        JOIN Customers c ON l.CustomerID = c.CustomerID
        WHERE l.DueDate <= SYSDATE + 30;

BEGIN
    FOR rec IN cur_due_loans LOOP
        DBMS_OUTPUT.PUT_LINE('Reminder: Loan for customer ' || rec.Name ||
                             ' (ID: ' || rec.CustomerID || ') is due on ' || TO_CHAR(rec.DueDate, 'DD-MON-YYYY'));
    END LOOP;
END;
SELECT l.CustomerID, c.Name, l.DueDate
FROM Loans l
JOIN Customers c ON l.CustomerID = c.CustomerID
WHERE l.DueDate <= SYSDATE + 30;



