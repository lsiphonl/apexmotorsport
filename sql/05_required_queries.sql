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
DEFINE Department_Code = ENG

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

-- RUBEN: RACE CALENDAR / SCHEDULING QUERIES
DEFINE Race_Calendar_Season = 2026
DEFINE Race_Calendar_TimeZone = CET

-- Limitation of rows and columns
SELECT Event_ID, Event_Date
FROM EVENT
WHERE ROWNUM <= 5;

-- Sorting
SELECT
    Event_ID,
    Season,
    Circuit_Location,
    Event_Date
FROM VW_RACE_EVENT_SCHEDULE
WHERE Season = &Race_Calendar_Season
ORDER BY Event_Date, Circuit_Location;

-- LIKE, AND and OR
SELECT
    Assignment_Code,
    Emp_FName,
    Emp_LName,
    Assignment_Desc
FROM VW_EMP_EVENT_ASSIGNMENTS
WHERE Assignment_Desc LIKE '%Driver%'
   OR (Assignment_Desc LIKE '%Engineer%' AND Expected_Arrival <= Event_Date);

-- Variables and character functions
SELECT
    Circuit_ID,
    UPPER(Circuit_Location) AS Circuit_Name,
    LOWER(Circuit_TimeZone) AS Time_Zone
FROM CIRCUIT
WHERE Circuit_TimeZone = '&Race_Calendar_TimeZone';

-- ROUND or TRUNC
SELECT
    Event_ID,
    Event_Date,
    TRUNC(Event_Date, 'MM') AS Event_Month,
    ROUND(Event_Date, 'YYYY') AS Rounded_Event_Year
FROM EVENT;

-- Date functions
SELECT
    Assignment_Code,
    Emp_FName || ' ' || Emp_LName AS Employee_Name,
    Event_Date,
    Expected_Arrival,
    Event_Date - Expected_Arrival AS Arrival_Lead_Days,
    ADD_MONTHS(Event_Date, 1) AS Follow_Up_Date
FROM VW_EMP_EVENT_ASSIGNMENTS;

-- Aggregate functions
SELECT
    COUNT(*) AS Total_Events,
    MIN(Event_Date) AS First_Event_Date,
    MAX(Event_Date) AS Last_Event_Date
FROM EVENT;

-- GROUP BY and HAVING
SELECT
    e.Event_ID,
    c.Circuit_Location,
    COUNT(eea.Assignment_Code) AS Assigned_Employees
FROM EVENT e
JOIN CIRCUIT c ON e.Circuit_ID = c.Circuit_ID
LEFT JOIN EMP_EVENT_ASSIGNMENT eea ON e.Event_ID = eea.Event_ID
GROUP BY e.Event_ID, c.Circuit_Location
HAVING COUNT(eea.Assignment_Code) >= 2;

-- Joins
SELECT
    eea.Assignment_Code,
    emp.Emp_FName || ' ' || emp.Emp_LName AS Employee_Name,
    c.Circuit_Location,
    e.Event_Date,
    eea.Expected_Arrival
FROM EMP_EVENT_ASSIGNMENT eea
JOIN EMPLOYEE emp ON eea.Emp_ID = emp.Emp_ID
JOIN EVENT e ON eea.Event_ID = e.Event_ID
JOIN CIRCUIT c ON e.Circuit_ID = c.Circuit_ID;

-- Sub-query
SELECT
    Event_ID,
    Circuit_ID,
    Season_ID,
    Event_Date
FROM EVENT
WHERE Event_Date = (
    SELECT MIN(Event_Date)
    FROM EVENT
);
