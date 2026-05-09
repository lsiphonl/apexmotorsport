--Select based on company requirements
SELECT
    s.Shipment_ID,
    e.Emp_FName || ' ' || e.Emp_LName AS Scheduled_By,
    c.Circuit_Location,
    s.Departure_Date,
    s.Arrival_Date,
    s.Status
FROM SHIPMENT s
JOIN EMPLOYEE e ON s.Emp_ID = e.Emp_ID
JOIN CIRCUIT c ON s.Circuit_ID = c.Circuit_ID;

--Limitations on rows and columns
SELECT Emp_ID, Emp_FName, Emp_LName
FROM EMPLOYEE
WHERE ROWNUM <= 3;

--Sorting
SELECT Sponsor_ID, Sponsor_Alias
FROM SPONSOR
ORDER BY Sponsor_Alias ASC;

--LIKE, AND, OR
SELECT Emp_ID, Emp_FName, Emp_LName, Emp_Type
FROM EMPLOYEE
WHERE Emp_Type LIKE '%Engineer%'
   OR (Emp_Gender = 'M' AND Department_Code = 'LOG');

--Variables + Character functions
SELECT
    UPPER(Emp_FName) AS First_Name,
    UPPER(Emp_LName) AS Last_Name,
    LENGTH(Emp_Email) AS Email_Length
FROM EMPLOYEE
WHERE Department_Code = '&Department_Code';

--Round/Trunk
SELECT
    Payment_ID,
    Payment_Amount,
    ROUND(Payment_Amount, 0) AS Rounded_Amount,
    TRUNC(Payment_Amount, 0) AS Truncated_Amount
FROM PAYMENT;

--Date query
SELECT
    Shipment_ID,
    Departure_Date,
    Arrival_Date,
    Arrival_Date - Departure_Date AS Travel_Days
FROM SHIPMENT;

-- Aggrgt functions
SELECT
    COUNT(*) AS Total_Payments,
    SUM(Payment_Amount) AS Total_Income,
    AVG(Payment_Amount) AS Average_Payment
FROM PAYMENT;

--Group and Having
SELECT
    Contract_ID,
    SUM(Payment_Amount) AS Total_Paid
FROM PAYMENT
GROUP BY Contract_ID
HAVING SUM(Payment_Amount) > 1000000;

--Joins
SELECT
    p.Payment_ID,
    s.Sponsor_Alias,
    c.Contract_Desc,
    p.Payment_Amount
FROM PAYMENT p
JOIN CONTRACT c ON p.Contract_ID = c.Contract_ID
JOIN SPONSOR_CONTRACT sc ON c.Contract_ID = sc.Contract_ID
JOIN SPONSOR s ON sc.Sponsor_ID = s.Sponsor_ID;

--SubQs
SELECT
    Payment_ID,
    Contract_ID,
    Payment_Amount
FROM PAYMENT
WHERE Payment_Amount > (
    SELECT AVG(Payment_Amount)
    FROM PAYMENT
);

--Extra Functionality
SELECT
    c.Circuit_Location,
    COUNT(s.Shipment_ID) AS Total_Shipments
FROM SHIPMENT s
JOIN CIRCUIT c
ON s.Circuit_ID = c.Circuit_ID
GROUP BY c.Circuit_Location
ORDER BY Total_Shipments DESC;
