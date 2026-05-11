CREATE VIEW VW_SHIPMENT_DETAILS AS
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

CREATE OR REPLACE VIEW VW_RACE_EVENT_SCHEDULE AS
SELECT
    e.Event_ID,
    s.Season,
    c.Circuit_ID,
    c.Circuit_Location,
    c.Circuit_TimeZone,
    e.Event_Date,
    COUNT(eea.Assignment_Code) AS Assigned_Employees
FROM EVENT e
JOIN SEASON s ON e.Season_ID = s.Season_ID
JOIN CIRCUIT c ON e.Circuit_ID = c.Circuit_ID
LEFT JOIN EMP_EVENT_ASSIGNMENT eea ON e.Event_ID = eea.Event_ID
GROUP BY
    e.Event_ID,
    s.Season,
    c.Circuit_ID,
    c.Circuit_Location,
    c.Circuit_TimeZone,
    e.Event_Date;

CREATE OR REPLACE VIEW VW_EMP_EVENT_ASSIGNMENTS AS
SELECT
    eea.Assignment_Code,
    emp.Emp_ID,
    emp.Emp_FName,
    emp.Emp_LName,
    e.Event_ID,
    e.Event_Date,
    c.Circuit_Location,
    eea.Expected_Arrival,
    eea.Assignment_Desc
FROM EMP_EVENT_ASSIGNMENT eea
JOIN EMPLOYEE emp ON eea.Emp_ID = emp.Emp_ID
JOIN EVENT e ON eea.Event_ID = e.Event_ID
JOIN CIRCUIT c ON e.Circuit_ID = c.Circuit_ID;
