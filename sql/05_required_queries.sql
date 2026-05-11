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

-- Show car with power unit with mileage less than 2500 and cureently fitted (Join)
SELECT
    pu.Part_Num,
    pu.Mileage,
    c.Car_ID
FROM POWER_UNIT pu
JOIN CAR_PART cp
ON pu.Part_Num = cp.Part_Num
JOIN CAR c
ON cp.Car_ID = c.Car_ID
WHERE pu.Mileage < 2500;

-- Display Car_Id and FIA_Car_Num where the total number of rows are less than or equal to 5 (Limit Rows/Columns)
SELECT Car_ID, FIA_Car_Num
FROM CAR
WHERE ROWNUM <= 5;

-- All power units along with their mileage in Descending order (Sorting)
SELECT *
FROM POWER_UNIT
ORDER BY Mileage DESC;

-- Total number of parts per part type (Group By/ Having)
SELECT
    Part_Type,
    COUNT(*) AS Total_Parts
FROM PART
GROUP BY Part_Type
HAVING COUNT(*) > 1;

-- Chassis that passed the crash test as well as being made of Carbon Fibre (LIKE/AND/OR)
SELECT Part_Num, Crash_Test_Status, Monocoque_Material, Weight
FROM CHASSIS
WHERE Crash_Test_Status = 'Passed'
  AND Monocoque_Material = 'CarbonFibre';
  
SELECT Part_Num, Aero_Component_Type, Specification_Version
FROM AERO_COMPONENT
WHERE Specification_Version LIKE 'v2%';

-- Aero Components displayed in lower case with its version (Variable/Character Functions)
SELECT Part_Num,
       LOWER(Aero_Component_Type) AS Component_Type_Lower,
       Specification_Version
FROM AERO_COMPONENT;

-- Gearbox mileage per race event (Round/Trunc)
SELECT Part_Num, Mileage, Race_Events_Used,
       CASE
           WHEN Race_Events_Used > 0
           THEN ROUND(Mileage / Race_Events_Used, 2)
           ELSE 0
       END AS Avg_KM_Per_Event
FROM GEARBOX;

-- How many days was a removed part was fitted before it was removed (Date Function)
SELECT Car_ID, Part_Num,
       Fitment_Date,
       Removal_Date,
       (Removal_Date - Fitment_Date)           AS Days_In_Use
FROM CAR_PART
WHERE Fitment_Status = 'Removed'
  AND Removal_Date IS NOT NULL;

-- Count the total number of parts in inventory (Aggreagte Functions)
SELECT COUNT(*) AS Total_Parts
FROM PART;

-- Cars with their current fitted parts (Inner Join)
SELECT c.Car_ID, c.FIA_Car_Num, c.Car_Status,
       p.Part_Num, p.Part_Type, p.Part_Condition,
       cp.Fitment_Date
FROM CAR c
INNER JOIN CAR_PART cp ON c.Car_ID    = cp.Car_ID
INNER JOIN PART p      ON cp.Part_Num = p.Part_Num
WHERE cp.Fitment_Status = 'Fitted';

-- Cars that have atleast one part fitted to it (Sub-Query)
SELECT Car_ID, FIA_Car_Num, Car_Status
FROM CAR
WHERE Car_ID IN (
    SELECT DISTINCT Car_ID
    FROM CAR_PART
    WHERE Fitment_Status = 'Fitted'
);