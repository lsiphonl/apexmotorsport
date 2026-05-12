-- Apex Motorsport Database
-- Views

-- Shipment Overview
-- Displays shipment details with employee and circuit information.
CREATE VIEW VW_SHIPMENT_OVERVIEW AS
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
    ON sh.Circuit_ID = c.Circuit_ID;

-- Race Result Summary
-- Displays race performance results with driver names.
CREATE VIEW VW_RACE_RESULT_SUMMARY AS
SELECT
    rr.Result_ID,
    ev.Event_ID,
    e.Emp_FName || ' ' || e.Emp_LName AS Driver_Name,
    rr.Final_Position,
    rr.Points_Awarded,
    rr.Fastest_Lap,
    rr.Status
FROM RACE_RESULT rr
JOIN DRIVER d
    ON rr.Emp_ID = d.Emp_ID
JOIN EMPLOYEE e
    ON d.Emp_ID = e.Emp_ID
JOIN EVENT ev
    ON rr.Event_ID = ev.Event_ID;

-- Telemetry Performance Summary
-- Displays average telemetry speed per car and session.
CREATE VIEW VW_TELEMETRY_SUMMARY AS
SELECT
    rs.Session_ID,
    rs.Session_Type,
    c.Car_ID,
    COUNT(t.Log_ID) AS Telemetry_Records,
    ROUND(AVG(t.Speed_kmh), 2) AS Average_Speed,
    MAX(t.Speed_kmh) AS Maximum_Speed
FROM TELEMETRY_LOG t
JOIN RACE_SESSION rs
    ON t.Session_ID = rs.Session_ID
JOIN CAR c
    ON t.Car_ID = c.Car_ID
GROUP BY rs.Session_ID, rs.Session_Type, c.Car_ID;

-- Sponsorship Payment Overview
-- Displays sponsor payments and contract information.
CREATE VIEW VW_SPONSOR_PAYMENTS AS
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
    ON sc.Sponsor_ID = s.Sponsor_ID;

-- Qualifying Session Summary
-- Displays qualifying performance and grid positions.
CREATE VIEW VW_QUALIFYING_SUMMARY AS
SELECT
    ql.Qual_Lap_ID,
    e.Emp_FName || ' ' || e.Emp_LName AS Driver_Name,
    ql.Segment,
    ql.Lap_Time,
    ql.Grid_Position
FROM QUALIFYING_LAP ql
JOIN EMPLOYEE e
    ON ql.Emp_ID = e.Emp_ID;
