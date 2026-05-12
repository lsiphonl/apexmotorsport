-- Apex Motorsport Database
-- Indexes

-- Speeds up employee lookups by department
CREATE INDEX IDX_EMPLOYEE_DEPARTMENT
ON EMPLOYEE(Department_Code);

-- Speeds up payment lookups by contract
CREATE INDEX IDX_PAYMENT_CONTRACT
ON PAYMENT(Contract_ID);

-- Speeds up shipment lookups by circuit
CREATE INDEX IDX_SHIPMENT_CIRCUIT
ON SHIPMENT(Circuit_ID);

-- Speeds up event lookups by circuit
CREATE INDEX IDX_EVENT_CIRCUIT
ON EVENT(Circuit_ID);

-- Speeds up event lookups by season
CREATE INDEX IDX_EVENT_SEASON
ON EVENT(Season_ID);

-- Speeds up session lookups by event
CREATE INDEX IDX_RACE_SESSION_EVENT
ON RACE_SESSION(Event_ID);

-- Speeds up telemetry analysis by session
CREATE INDEX IDX_TELEMETRY_SESSION
ON TELEMETRY_LOG(Session_ID);

-- Speeds up telemetry analysis by car
CREATE INDEX IDX_TELEMETRY_CAR
ON TELEMETRY_LOG(Car_ID);

-- Speeds up fuel analysis by session
CREATE INDEX IDX_FUEL_SESSION
ON FUEL_CONSUMPTION(Session_ID);

-- Speeds up race result lookup by event
CREATE INDEX IDX_RACE_RESULT_EVENT
ON RACE_RESULT(Event_ID);
