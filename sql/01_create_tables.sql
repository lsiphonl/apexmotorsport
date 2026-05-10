--INTELLIGENT KEYS??? (EMP001)
--Subtype entities to be added(ENGINEER, DRIVER, MECHANIC, PITCREW_MEMBER)??

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
    Circuit_TimeZone VARCHAR2(50)
);

CREATE TABLE SEASON (
    Season_ID NUMBER PRIMARY KEY,
    Season NUMBER(4) NOT NULL
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
  Asset_Quantity NUMBER CHECK (Asset_Quantity > 0)
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








CREATE TABLE EVENT --blank table, needed the FK :)
(
    Event_ID        NUMBER(5),
    CONSTRAINT PK_EVENT
        PRIMARY KEY (Event_ID)
);





CREATE TABLE CAR
(
    Car_ID         NUMBER(3),
    Car_Weight     NUMBER(6,2),     -- kilograms
    Car_Status     VARCHAR2(20),    -- Operational/Non-Operational/InForService/Retired
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
    Part_Num          NUMBER(5),
    Part_Type         VARCHAR2(5),   -- AC/C/PU/TS/G/O - AeroComponent/Chassis/PowerUnit/TyreSet/Gearbox/Other
    Part_Condition    VARCHAR2(20),  -- New/Used/Damaged
    Asset_ID          NUMBER(10) NOT NULL,

    CONSTRAINT PK_Part_Num
        PRIMARY KEY (Part_Num),

    CONSTRAINT FK_Asset_ID
        FOREIGN KEY (Asset_ID)
        REFERENCES ASSET(Asset_ID),
    CHECK (Part_Type IN ('AC','C','PU','TS','G','O')) -- AeroComponent/Chassis/PowerUnit/TyreSet/Gearbox/Other
);

CREATE TABLE CAR_PART
(
    Car_ID            NUMBER(3),
    Part_Num          NUMBER(5),
    Event_ID          NUMBER(5),
    Fitment_Date      DATE,
    Removal_Date      DATE,
    Fitment_Status    VARCHAR2(15),   -- Fitted/Removed

    CONSTRAINT PK_CAR_PART
        PRIMARY KEY (Car_ID, Part_Num),

    CONSTRAINT FK_CP_CAR
        FOREIGN KEY (Car_ID)
        REFERENCES CAR(Car_ID),

    CONSTRAINT FK_CP_PART
        FOREIGN KEY (Part_Num)
        REFERENCES PART(Part_Num),

    CONSTRAINT FK_CP_Event_ID
        FOREIGN KEY (Event_ID)
        REFERENCES EVENT(Event_ID)
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

CREATE TABLE TYRE
(
    Part_Num           NUMBER(5),
    Laps_Done          NUMBER(3),
    Compound_Type      VARCHAR2(20),  --c1/c2/c3/c4/c5/c6
    Wear_Percentage    NUMBER(5,2) DEFAULT 100.00,
    
    CONSTRAINT PK_TYRE
        PRIMARY KEY (Part_Num),

    CONSTRAINT FK_TYRE_PART
        FOREIGN KEY (Part_Num)
        REFERENCES PART(Part_Num),
    CHECK (Wear_Percentage BETWEEN 0 AND 100)
);

CREATE TABLE PITCREW_MEMBER
(
    Emp_ID         NUMBER(10),
    PitcrewSection VARCHAR2(20),

    CONSTRAINT PK_PITCREW_MEMBER
        PRIMARY KEY (Emp_ID),

    CONSTRAINT FK_PM_EMPLOYEE
        FOREIGN KEY (Emp_ID)
        REFERENCES EMPLOYEE(Emp_ID)
);


CREATE TABLE MECHANIC
(
    Emp_ID          NUMBER(10),
    Engineer_Emp_ID NUMBER(10),
    Speciality      VARCHAR2(20),

    CONSTRAINT PK_MECHANIC
        PRIMARY KEY (Emp_ID),

    CONSTRAINT FK_MC_ENGINEER
        FOREIGN KEY (Engineer_Emp_ID)
        REFERENCES ENGINEER(Emp_ID),

    CONSTRAINT FK_MC_EMPLOYEE
        FOREIGN KEY (Emp_ID)
        REFERENCES EMPLOYEE(Emp_ID)
);