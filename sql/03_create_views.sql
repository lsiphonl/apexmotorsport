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
