-- Apex Motorsport Database
-- Phase 3 Required Queries

-- LIMITATION OF ROWS AND COLUMNS
-- Display only selected employee columns and limit output to 5 rows.
SELECT Emp_ID, Emp_FName, Emp_LName, Emp_Type
FROM EMPLOYEE
WHERE ROWNUM <= 5;
-- Display only selected car columns and limit output to 3 rows
SELECT Car_ID, Car_Status, FIA_Car_Num
FROM CAR
WHERE ROWNUM <= 3;

-- SORTING
-- Display sponsors alphabetically.
SELECT Sponsor_ID, Sponsor_Alias
FROM SPONSOR
ORDER BY Sponsor_Alias ASC;
-- Display circuits sorted by location
SELECT Circuit_ID, Circuit_Location
FROM CIRCUIT
ORDER BY Circuit_Location ASC;

-- LIKE, AND, OR
-- Find employees who are drivers/engineers or belong to logistics.
SELECT Emp_ID, Emp_FName, Emp_LName, Emp_Type, Department_Code
FROM EMPLOYEE
WHERE Emp_Type LIKE '%Engineer%'
   OR Emp_Type LIKE '%Driver%'
   OR Department_Code = 'LOG';
-- Find mechanics and pit crew members
SELECT Emp_ID, Emp_FName, Emp_LName, Emp_Type
FROM EMPLOYEE
WHERE Emp_Type LIKE '%Mechanic%'
   OR Emp_Type LIKE '%Pit Crew%';

-- VARIABLES AND CHARACTER FUNCTIONS
-- Search employees by department and display names in uppercase.
-- Example input: ENG
SELECT
    UPPER(Emp_FName) AS First_Name,
    UPPER(Emp_LName) AS Last_Name,
    LENGTH(Emp_Email) AS Email_Length,
    Department_Code
FROM EMPLOYEE
WHERE Department_Code = '&Department_Code';
-- Display sponsor aliases in lowercase
SELECT
    LOWER(Sponsor_Alias) AS Sponsor_Name,
    LENGTH(Sponsor_Alias) AS Name_Length
FROM SPONSOR;

-- ROUND AND/OR TRUNC
-- Display payment amounts rounded and truncated.
SELECT
    Payment_ID,
    Payment_Amount,
    ROUND(Payment_Amount, 0) AS Rounded_Amount,
    TRUNC(Payment_Amount, 0) AS Truncated_Amount
FROM PAYMENT;
-- Round telemetry speeds
SELECT
    Log_ID,
    Speed_kmh,
    ROUND(Speed_kmh, 1) AS Rounded_Speed,
    TRUNC(Speed_kmh, 1) AS Truncated_Speed
FROM TELEMETRY_LOG;

-- DATE FUNCTIONS
-- Calculate the number of travel days for each shipment.
SELECT
    Shipment_ID,
    Departure_Date,
    Arrival_Date,
    Arrival_Date - Departure_Date AS Travel_Days
FROM SHIPMENT;
-- Display current system date and contract age
SELECT
    Contract_ID,
    DateOfAgreement,
    SYSDATE AS Current_Date,
    SYSDATE - DateOfAgreement AS Days_Since_Agreement
FROM CONTRACT;

-- AGGREGATE FUNCTIONS
-- Calculate payment summary statistics.
SELECT
    COUNT(*) AS Total_Payments,
    SUM(Payment_Amount) AS Total_Income,
    AVG(Payment_Amount) AS Average_Payment,
    MAX(Payment_Amount) AS Highest_Payment,
    MIN(Payment_Amount) AS Lowest_Payment
FROM PAYMENT;
-- Calculate average telemetry speed
SELECT
    AVG(Speed_kmh) AS Average_Speed,
    MAX(Speed_kmh) AS Max_Speed,
    MIN(Speed_kmh) AS Min_Speed
FROM TELEMETRY_LOG;

-- GROUP BY AND HAVING
-- Show contracts with total payments above R1 000 000.
SELECT
    Contract_ID,
    SUM(Payment_Amount) AS Total_Paid
FROM PAYMENT
GROUP BY Contract_ID
HAVING SUM(Payment_Amount) > 1000000
ORDER BY Total_Paid DESC;
-- Count telemetry records per session
SELECT
    Session_ID,
    COUNT(*) AS Total_Logs
FROM TELEMETRY_LOG
GROUP BY Session_ID
HAVING COUNT(*) > 2;

-- JOINS
-- Display sponsor payments with contract descriptions.
SELECT
    p.Payment_ID,
    s.Sponsor_Alias,
    c.Contract_Desc,
    p.Payment_Amount,
    p.Transaction_Date
FROM PAYMENT p
JOIN CONTRACT c
    ON p.Contract_ID = c.Contract_ID
JOIN SPONSOR_CONTRACT sc
    ON c.Contract_ID = sc.Contract_ID
JOIN SPONSOR s
    ON sc.Sponsor_ID = s.Sponsor_ID
ORDER BY p.Payment_Amount DESC;
-- Display car and assigned driver
SELECT
    c.Car_ID,
    c.Car_Status,
    e.Emp_FName || ' ' || e.Emp_LName AS Driver_Name
FROM CAR c
JOIN EMPLOYEE e
ON c.Emp_ID = e.Emp_ID;

-- SUB-QUERIES
-- Display payments above the average payment amount.
SELECT
    Payment_ID,
    Contract_ID,
    Payment_Amount
FROM PAYMENT
WHERE Payment_Amount > (
    SELECT AVG(Payment_Amount)
    FROM PAYMENT
);
-- Find drivers with race points above average
SELECT
    rr.Emp_ID,
    rr.Points_Awarded
FROM RACE_RESULT rr
WHERE rr.Points_Awarded >
(
    SELECT AVG(Points_Awarded)
    FROM RACE_RESULT
);

-- COMPANY INFORMATION REQUIREMENT QUERY
-- Show race session telemetry summary per car.
SELECT
    rs.Session_ID,
    rs.Session_Type,
    c.Car_ID,
    COUNT(t.Log_ID) AS Telemetry_Records,
    ROUND(AVG(t.Speed_kmh), 2) AS Average_Speed
FROM TELEMETRY_LOG t
JOIN RACE_SESSION rs
    ON t.Session_ID = rs.Session_ID
JOIN CAR c
    ON t.Car_ID = c.Car_ID
GROUP BY rs.Session_ID, rs.Session_Type, c.Car_ID
ORDER BY rs.Session_ID, c.Car_ID;
-- Display weather conditions recorded during sessions
SELECT
    rs.Session_Type,
    wc.Track_Condition,
    wc.Air_Temp_Celsius,
    wc.Track_Temp_Celsius
FROM WEATHER_CONDITION wc
JOIN RACE_SESSION rs
ON wc.Session_ID = rs.Session_ID;

-- LOGISTICS QUERY
-- Show shipments, assigned employees, and destination circuits.
SELECT
    sh.Shipment_ID,
    e.Emp_FName || ' ' || e.Emp_LName AS Scheduled_By,
    c.Circuit_Location,
    sh.Departure_Date,
    sh.Arrival_Date,
    CASE sh.Status
        WHEN 1 THEN 'Not Shipped Yet'
        WHEN 2 THEN 'In Transit'
        WHEN 3 THEN 'Received'
    END AS Shipment_Status
FROM SHIPMENT sh
JOIN EMPLOYEE e
    ON sh.Emp_ID = e.Emp_ID
JOIN CIRCUIT c
    ON sh.Circuit_ID = c.Circuit_ID
ORDER BY sh.Departure_Date;
-- Display shipped assets and shipment destinations
SELECT
    sa.Shipment_ID,
    a.Asset_Description,
    c.Circuit_Location
FROM SHIPPED_ASSET sa
JOIN ASSET a
ON sa.Asset_ID = a.Asset_ID
JOIN SHIPMENT s
ON sa.Shipment_ID = s.Shipment_ID
JOIN CIRCUIT c
ON s.Circuit_ID = c.Circuit_ID;

-- PERFORMANCE QUERY
-- Purpose: Display race results with driver names.
SELECT
    ev.Event_ID,
    e.Emp_FName || ' ' || e.Emp_LName AS Driver_Name,
    rr.Final_Position,
    rr.Points_Awarded,
    rr.Fastest_Lap
FROM RACE_RESULT rr
JOIN DRIVER d
    ON rr.Emp_ID = d.Emp_ID
JOIN EMPLOYEE e
    ON d.Emp_ID = e.Emp_ID
JOIN EVENT ev
    ON rr.Event_ID = ev.Event_ID
ORDER BY ev.Event_ID, rr.Final_Position;
-- Display qualifying lap times
SELECT
    e.Emp_FName || ' ' || e.Emp_LName AS Driver_Name,
    ql.Segment,
    ql.Lap_Time,
    ql.Grid_Position
FROM QUALIFYING_LAP ql
JOIN EMPLOYEE e
ON ql.Emp_ID = e.Emp_ID
ORDER BY ql.Grid_Position;
