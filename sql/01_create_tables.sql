CREATE TABLE DEPARTMENT (
    Department_Code VARCHAR2(10) PRIMARY KEY,
    Department_Description VARCHAR2(100) NOT NULL
);

CREATE TABLE EMPLOYEE (
    Emp_ID NUMBER PRIMARY KEY,
    Department_Code VARCHAR2(10) NOT NULL,
    Emp_FName VARCHAR2(50) NOT NULL,
    Emp_LName VARCHAR2(50) NOT NULL,
    Emp_DOB DATE,
    Emp_Contact VARCHAR2(20),
    Emp_Email VARCHAR2(100),
    Emp_Gender CHAR(1),
    Emp_Type VARCHAR2(30),

    CONSTRAINT FK_EMPLOYEE_DEPARTMENT
    FOREIGN KEY (Department_Code)
    REFERENCES DEPARTMENT(Department_Code)
);

CREATE TABLE SPONSOR (
    Sponsor_ID NUMBER PRIMARY KEY,
    Sponsor_Alias VARCHAR2(100) NOT NULL
);

CREATE TABLE CONTRACT (
    Contract_ID NUMBER PRIMARY KEY,
    Contract_Period VARCHAR2(50),
    Contract_Desc VARCHAR2(200),
    DateOfAgreement DATE
);

CREATE TABLE EMP_CONTRACT(
  Contract_ID NUMBER NOT NULL,
  Emp_ID NUMBER NOT NULL,

  CONSTRAINT PK_EMP_CONTRACT PRIMARY KEY(Contract_ID, Emp_ID),

  CONSTRAINT FK_EMP_CONTRACT1 FOREIGN KEY(Contract_ID) REFERENCES CONTRACT(Contract_ID),
  CONSTRAINT FK_EMP_CONTRACT2 FOREIGN KEY(Emp_ID) REFERENCES EMPLOYEE(Emp_ID)
);

CREATE TABLE SPONSOR_CONTRACT(
  Contract_ID NUMBER NOT NULL,
  Sponsor_ID NUMBER NOT NULL,

  CONSTRAINT PK_SPONSOR_CONTRACT PRIMARY KEY(Contract_ID, Sponsor_ID),

  CONSTRAINT FK_SPONSOR_CONTRACT1 FOREIGN KEY(Contract_ID) REFERENCES CONTRACT(Contract_ID),
  CONSTRAINT FK_SPONSOR_CONTRACT2 FOREIGN KEY(Sponsor_ID) REFERENCES SPONSOR(Sponsor_ID)
);

CREATE TABLE CIRCUIT (
    Circuit_ID NUMBER PRIMARY KEY,
    Circuit_Location VARCHAR2(100) NOT NULL,
    Circuit_TimeZone VARCHAR2(50) NOT NULL
);

CREATE TABLE SEASON (
    Season_ID NUMBER PRIMARY KEY,
    Season NUMBER(4) NOT NULL,
    CONSTRAINT CHK_SEASON_YEAR CHECK (Season BETWEEN 1950 AND 2100)
);

CREATE TABLE PAYMENT (
    Payment_ID NUMBER PRIMARY KEY,
    Contract_ID NUMBER NOT NULL,
    Payment_Amount NUMBER(10,2),
    Transaction_Date DATE NOT NULL,

    CONSTRAINT FK_Contract_Payment
    FOREIGN KEY (Contract_ID)
    REFERENCES CONTRACT(Contract_ID)
);

CREATE TABLE SHIPMENT(
  Shipment_ID NUMBER PRIMARY KEY,
  Emp_ID NUMBER NOT NULL,
  Circuit_ID NUMBER NOT NULL,
  Departure_Date DATE,
  Arrival_Date DATE,
  Status NUMBER(1) CHECK(Status IN(1,2,3)), -- 1: NOT SHIPPED YET/2: IN TRANSIT/3: RECEIVED

  CONSTRAINT FK_Emp_Shipment FOREIGN KEY (Emp_ID) REFERENCES EMPLOYEE(Emp_ID),
  CONSTRAINT FK_Shipment_Circuit FOREIGN KEY(Circuit_ID) REFERENCES CIRCUIT(Circuit_ID)
);

CREATE TABLE ASSET(
  Asset_ID NUMBER PRIMARY KEY,
  Asset_Description VARCHAR2(100) NOT NULL,
  Asset_Quantity NUMBER CHECK (Asset_Quantity >= 0)
);

CREATE TABLE SHIPPED_ASSET(
    Shipment_ID NUMBER NOT NULL,
    Asset_ID NUMBER NOT NULL,

    CONSTRAINT PK_SHIPPED_ASSET
    PRIMARY KEY (Shipment_ID, Asset_ID),

    CONSTRAINT FK_SHIPMENT_ASSET1
    FOREIGN KEY (Shipment_ID)
    REFERENCES SHIPMENT(Shipment_ID),

    CONSTRAINT FK_SHIPMENT_ASSET2
    FOREIGN KEY (Asset_ID)
    REFERENCES ASSET(Asset_ID)
);

CREATE TABLE EVENT (
    Event_ID NUMBER PRIMARY KEY,
    Circuit_ID NUMBER NOT NULL,
    Season_ID NUMBER NOT NULL,
    Event_Date DATE NOT NULL,

    CONSTRAINT FK_EVENT_CIRCUIT
    FOREIGN KEY (Circuit_ID)
    REFERENCES CIRCUIT(Circuit_ID),

    CONSTRAINT FK_EVENT_SEASON
    FOREIGN KEY (Season_ID)
    REFERENCES SEASON(Season_ID),
    CONSTRAINT CHK_EVENT_DATE CHECK (Event_Date >= DATE '1950-01-01')
);

CREATE TABLE CAR
(
    Car_ID         NUMBER(3),
    Car_Weight     NUMBER(6,2),     -- kilograms
    Car_Status     VARCHAR2(20), 
    CONSTRAINT  Car_Status_Constraint CHECK
    (Car_Status IN (
    'Operational',
    'Non-Operational',
    'InForService',
    'Retired')),

    FIA_Car_Num    NUMBER(2) NOT NULL,
    Season_Used    NUMBER(4),
    Emp_ID         NUMBER(10) NOT NULL,

    CONSTRAINT PK_Car_ID
        PRIMARY KEY (Car_ID),

    CONSTRAINT Car_Emp_ID
        FOREIGN KEY (Emp_ID)
        REFERENCES EMPLOYEE(Emp_ID),
    CHECK(Car_Weight>=0)
);

CREATE TABLE PART
(
    Part_Num NUMBER(5),
    Part_Type VARCHAR2(5) CHECK (Part_Type IN ('AC','C','PU','TS','G','O')),   -- AC/C/PU/TS/G/O - AeroComponent/Chassis/PowerUnit/TyreSet/Gearbox/Other
    Part_Condition VARCHAR2(20) CHECK (Part_Condition IN ('New','Used','Damaged')),  -- New/Used/Damaged
    Asset_ID NUMBER(10) NOT NULL,

    CONSTRAINT PK_Part_Num PRIMARY KEY (Part_Num),
    CONSTRAINT FK_Asset_ID FOREIGN KEY (Asset_ID)
    REFERENCES ASSET(Asset_ID)
);

CREATE TABLE CAR_PART(
    Car_ID NUMBER(3),
    Part_Num NUMBER(5),
    Event_ID NUMBER(5),
    Fitment_Date DATE,
    Removal_Date DATE,
    Fitment_Status VARCHAR2(15) CHECK (Fitment_Status IN ('Fitted','Removed')), -- Fitted/Removed

    CONSTRAINT PK_CAR_PART PRIMARY KEY (Car_ID, Part_Num, Event_ID),
    CONSTRAINT FK_CP_CAR FOREIGN KEY (Car_ID) REFERENCES CAR(Car_ID),
    CONSTRAINT FK_CP_PART FOREIGN KEY (Part_Num) REFERENCES PART(Part_Num),
    CONSTRAINT FK_CP_Event_ID FOREIGN KEY (Event_ID) REFERENCES EVENT(Event_ID)
);

CREATE TABLE AERO_COMPONENT
(
    Part_Num                  NUMBER(5),
    Aero_Component_Type       VARCHAR2(15),                  -- FrontWing/RearWing
    Specification_Version     VARCHAR2(10) DEFAULT 'v1.0',

    CONSTRAINT PK_AERO
        PRIMARY KEY (Part_Num),

    CONSTRAINT FK_AERO_PART
        FOREIGN KEY (Part_Num)
        REFERENCES PART(Part_Num)
);

CREATE TABLE CHASSIS
(
    Part_Num                 NUMBER(5),
    Crash_Test_Status        VARCHAR2(20),  -- Passed/Failed/ToBeDetermined
    Monocoque_Material       VARCHAR2(30),  -- CarbonFibre/Aluminium
    Weight                   NUMBER(5,2),   -- kg
    FIA_Certification_Ref    VARCHAR2(50),

    CONSTRAINT PK_CHASSIS
        PRIMARY KEY (Part_Num),

    CONSTRAINT FK_CHASSIS_PART
        FOREIGN KEY (Part_Num)
        REFERENCES PART(Part_Num),
    CHECK(Weight>=0)
);

CREATE TABLE POWER_UNIT
(
    Part_Num         NUMBER(5),
    Horse_Power      NUMBER(4),
    Mileage          NUMBER(6,2),  -- km

    CONSTRAINT PK_POWER_UNIT
        PRIMARY KEY (Part_Num),

    CONSTRAINT FK_POWER_UNIT_PART
        FOREIGN KEY (Part_Num)
        REFERENCES PART(Part_Num),
    CHECK(Horse_Power>=0),
    CHECK(Mileage>=0)
);

CREATE TABLE GEARBOX
(
    Part_Num             NUMBER(5),
    Mileage              NUMBER(6,2) DEFAULT 0,  -- km
    Num_Of_Gears         NUMBER(2),
    Race_Events_Used     NUMBER(2) DEFAULT 0,

    CONSTRAINT PK_GEARBOX
        PRIMARY KEY (Part_Num),

    CONSTRAINT FK_GEARBOX_PART
        FOREIGN KEY (Part_Num)
        REFERENCES PART(Part_Num)
);

--Deleted tyre entity

--Deleted duplicate mechanic and crew member entities
-- ============================================================
-- SESSION DATA & TECHNICAL DATA TABLES
-- ============================================================

CREATE TABLE DRIVER (
    Emp_ID       NUMBER PRIMARY KEY,
    F1_Ranking   NUMBER(2),
    Country      VARCHAR2(50),
    CONSTRAINT FK_DRIVER_EMP FOREIGN KEY (Emp_ID)
        REFERENCES EMPLOYEE(Emp_ID)
);

CREATE TABLE ENGINEER (
    Emp_ID        NUMBER PRIMARY KEY,
    Driver_Emp_ID NUMBER,
    CONSTRAINT FK_ENGINEER_EMP FOREIGN KEY (Emp_ID)
    REFERENCES EMPLOYEE(Emp_ID),
    CONSTRAINT FK_ENGINEER_DRIVER FOREIGN KEY(Driver_Emp_ID)
    REFERENCES DRIVER(Emp_ID)
);

CREATE TABLE MECHANIC (
    Emp_ID          NUMBER PRIMARY KEY,
    Engineer_Emp_ID NUMBER,
    Speciality      VARCHAR2(50),
    CONSTRAINT FK_MECHANIC_EMP FOREIGN KEY (Emp_ID)
    REFERENCES EMPLOYEE(Emp_ID),
    CONSTRAINT FK_MECHANIC_ENGINEER FOREIGN KEY(Engineer_Emp_ID) REFERENCES ENGINEER(Emp_ID)
);

CREATE TABLE PITCREW_MEMBER (
    Emp_ID NUMBER PRIMARY KEY,
    Pitcrew_Section VARCHAR2(50),
    CONSTRAINT FK_PITCREW_EMP FOREIGN KEY (Emp_ID)
    REFERENCES EMPLOYEE(Emp_ID)
);

CREATE TABLE TIRE_SET (
    Part_Num        NUMBER(5) PRIMARY KEY,
    Laps_Done       NUMBER(3),
    Compound        VARCHAR2(20),
    Total_Lap_KM    NUMBER(8,3),
    Wear_Percentage NUMBER(5,2),
    CONSTRAINT FK_TIRE_PART FOREIGN KEY (Part_Num)
        REFERENCES PART(Part_Num),
    CHECK (Wear_Percentage BETWEEN 0 AND 100)
);

CREATE TABLE EMP_EVENT_ASSIGNMENT (
    Assignment_Code NUMBER PRIMARY KEY,
    Emp_ID          NUMBER NOT NULL,
    Event_ID        NUMBER NOT NULL,
    Expected_Arrival DATE NOT NULL,
    Assignment_Desc VARCHAR2(200) NOT NULL,
    CONSTRAINT FK_EEA_EMP   FOREIGN KEY (Emp_ID)
    REFERENCES EMPLOYEE(Emp_ID),
    CONSTRAINT FK_EEA_EVENT FOREIGN KEY (Event_ID)
    REFERENCES EVENT(Event_ID),
    CONSTRAINT UQ_EEA_EMP_EVENT UNIQUE (Emp_ID, Event_ID)
);

CREATE TABLE RACE_SESSION (--Changed name to SESSION
    Session_ID    NUMBER(10) CONSTRAINT PK_SESSION PRIMARY KEY,
    Event_ID      NUMBER(10) NOT NULL
                  CONSTRAINT FK_SESSION_EVENT REFERENCES EVENT(Event_ID),
    Session_Type  VARCHAR2(20) NOT NULL,
    Start_Time    TIMESTAMP NOT NULL,
    Best_Lap_Time NUMBER(10,3),
    isPractice    CHAR(1) DEFAULT 'N'
                  CONSTRAINT CHK_SESSION_PRACTICE
                      CHECK (isPractice IN ('Y','N'))
);

CREATE TABLE DRIVER_SESSION (
    Emp_ID NUMBER(10) CONSTRAINT FK_DS_EMP
    REFERENCES DRIVER(Emp_ID),
    Session_ID NUMBER(10) CONSTRAINT FK_DS_SESSION
    REFERENCES RACE_SESSION(Session_ID),
    CONSTRAINT PK_DRIVER_SESSION PRIMARY KEY (Emp_ID, Session_ID)
);

CREATE TABLE PITSTOP (
    PS_ID NUMBER(10) CONSTRAINT PK_PITSTOP PRIMARY KEY,
    Session_ID NUMBER(10) NOT NULL CONSTRAINT FK_PS_SESSION REFERENCES RACE_SESSION(Session_ID),
    Car_ID NUMBER(10) NOT NULL CONSTRAINT FK_PS_CAR REFERENCES CAR(Car_ID),
    Lap_Number NUMBER(3)  NOT NULL,
    Duration_Sec NUMBER(6,3) NOT NULL,
    Stop_Type VARCHAR2(20) DEFAULT 'TYRE_CHANGE' CONSTRAINT CHK_PS_TYPE CHECK (Stop_Type IN ('TYRE_CHANGE','FRONT_WING','NOSE_CHANGE', 'DRIVE_THROUGH','REPAIR','RETIRE')),
    CONSTRAINT CHK_PS_DUR CHECK (Duration_Sec > 0),
    CONSTRAINT CHK_PS_LAP CHECK (Lap_Number > 0)
);

CREATE TABLE PITCREW_ASSIGNMENT(
    Emp_ID NUMBER NOT NULL,
    PS_ID NUMBER(10) NOT NULL,

    CONSTRAINT PK_PITCREW_ASSIGNMENT
    PRIMARY KEY (PS_ID, Emp_ID),

    CONSTRAINT FK_PCA_PITSTOP
    FOREIGN KEY (PS_ID)
    REFERENCES PITSTOP(PS_ID),

    CONSTRAINT FK_PCA_EMPLOYEE
    FOREIGN KEY (Emp_ID)
    REFERENCES EMPLOYEE(Emp_ID)

);

CREATE TABLE WEATHER_CONDITION (
    Condition_ID       NUMBER(10) CONSTRAINT PK_WEATHER PRIMARY KEY,
    Session_ID         NUMBER(10) NOT NULL
                       CONSTRAINT FK_WC_SESSION
                           REFERENCES RACE_SESSION(Session_ID),
    Recorded_At        TIMESTAMP  NOT NULL,
    Air_Temp_Celsius   NUMBER(5,2) NOT NULL,
    Track_Temp_Celsius NUMBER(5,2) NOT NULL,
    Humidity_pct       NUMBER(5,2) NOT NULL,
    Wind_Speed_kmh     NUMBER(6,2) NOT NULL,
    Track_Condition    VARCHAR2(15) DEFAULT 'DRY'
                       CONSTRAINT CHK_WC_COND CHECK (Track_Condition IN (
                           'DRY','WET','INTERMEDIATE','DAMP','FLOODED')),
    CONSTRAINT CHK_WC_HUM  CHECK (Humidity_pct BETWEEN 0 AND 100),
    CONSTRAINT CHK_WC_WIND CHECK (Wind_Speed_kmh >= 0)
);

CREATE TABLE TELEMETRY_LOG (
    Log_ID       NUMBER(10) CONSTRAINT PK_TELEMETRY PRIMARY KEY,
    Session_ID   NUMBER(10) NOT NULL
                 CONSTRAINT FK_TL_SESSION
                     REFERENCES RACE_SESSION(Session_ID),
    Car_ID       NUMBER(10) NOT NULL
                 CONSTRAINT FK_TL_CAR
                     REFERENCES CAR(Car_ID),
    Recorded_At  TIMESTAMP  NOT NULL,
    Speed_kmh    NUMBER(6,3) NOT NULL,
    Gear         NUMBER(1)   NOT NULL,
    Throttle_pct NUMBER(5,2) NOT NULL,
    Brake_pct    NUMBER(5,2) NOT NULL,
    Lap_Number   NUMBER(3)   NOT NULL,
    DRS_Active   CHAR(1) DEFAULT 'N'
                 CONSTRAINT CHK_TL_DRS CHECK (DRS_Active IN ('Y','N')),
    CONSTRAINT CHK_TL_SPEED    CHECK (Speed_kmh >= 0),
    CONSTRAINT CHK_TL_GEAR     CHECK (Gear BETWEEN 0 AND 8),
    CONSTRAINT CHK_TL_THROTTLE CHECK (Throttle_pct BETWEEN 0 AND 100),
    CONSTRAINT CHK_TL_BRAKE    CHECK (Brake_pct BETWEEN 0 AND 100)
);

CREATE TABLE FUEL_CONSUMPTION (
    Fuel_ID         NUMBER(10) CONSTRAINT PK_FUEL PRIMARY KEY,
    Session_ID      NUMBER(10) NOT NULL
                    CONSTRAINT FK_FC_SESSION
                        REFERENCES RACE_SESSION(Session_ID),
    Car_ID          NUMBER(10) NOT NULL
                    CONSTRAINT FK_FC_CAR
                        REFERENCES CAR(Car_ID),
    Fuel_Load_Start NUMBER(5,2) NOT NULL,
    Fuel_Used_Lap   NUMBER(5,3) NOT NULL,
    Recorded_At     TIMESTAMP   NOT NULL,
    Lap_Number      NUMBER(3)   NOT NULL,
    Fuel_Remaining  NUMBER(5,2),
    CONSTRAINT CHK_FC_LOAD CHECK (Fuel_Load_Start > 0),
    CONSTRAINT CHK_FC_USED CHECK (Fuel_Used_Lap >= 0),
    CONSTRAINT CHK_FC_REM  CHECK (Fuel_Remaining >= 0),
    CONSTRAINT CHK_FC_LAP  CHECK (Lap_Number > 0)
);

CREATE TABLE RACE_RESULT (
    Result_ID       NUMBER(10) CONSTRAINT PK_RESULT PRIMARY KEY,
    Event_ID        NUMBER(10) NOT NULL
                    CONSTRAINT FK_RR_EVENT
                        REFERENCES EVENT(Event_ID),
    Emp_ID NUMBER(10) NOT NULL CONSTRAINT FK_RR_EMP REFERENCES DRIVER(Emp_ID),
    Final_Position  NUMBER(2),
    Status VARCHAR2(15) DEFAULT 'FINISHED' CONSTRAINT CHK_RR_STATUS CHECK (Status IN ('FINISHED','DNF','DNS','DSQ','CLASSIFIED')),
    Total_Race_Time NUMBER(10,3),
    Fastest_Lap NUMBER(10,3),
    Points_Awarded  NUMBER(4,1) DEFAULT 0,
    CONSTRAINT CHK_RR_POS CHECK (Final_Position BETWEEN 1 AND 20),
    CONSTRAINT CHK_RR_PTS CHECK (Points_Awarded >= 0),
    CONSTRAINT UQ_RR_EVENT_EMP UNIQUE (Event_ID, Emp_ID)
);

CREATE TABLE QUALIFYING_LAP (
    Qual_Lap_ID   NUMBER(10) CONSTRAINT PK_QUAL PRIMARY KEY,
    Event_ID      NUMBER(10) NOT NULL
                  CONSTRAINT FK_QL_EVENT
                      REFERENCES EVENT(Event_ID),
    Emp_ID        NUMBER(10) NOT NULL
                  CONSTRAINT FK_QL_EMP
                      REFERENCES EMPLOYEE(Emp_ID),
    Tire_Set_Num  NUMBER(10) NOT NULL
                  CONSTRAINT FK_QL_TIRE
                      REFERENCES TIRE_SET(Part_Num),
    Lap_Time      NUMBER(10,3) NOT NULL,
    Segment       VARCHAR2(3) NOT NULL
                  CONSTRAINT CHK_QL_SEG CHECK (Segment IN ('Q1','Q2','Q3')),
    Lap_Number    NUMBER(2)   NOT NULL,
    Grid_Position NUMBER(2),
    CONSTRAINT CHK_QL_LAPTIME CHECK (Lap_Time > 0),
    CONSTRAINT CHK_QL_LAPNUM  CHECK (Lap_Number > 0),
    CONSTRAINT CHK_QL_GRID    CHECK (Grid_Position BETWEEN 1 AND 20)
);
