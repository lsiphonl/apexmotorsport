-- =========================
-- INITIAL SIMULATION DATA
-- Apex Motorsport Database
-- =========================

-- DEPARTMENT
INSERT INTO DEPARTMENT VALUES ('LOG', 'Logistics and Transportation');
INSERT INTO DEPARTMENT VALUES ('BUS', 'Business and Sponsorship Management');
INSERT INTO DEPARTMENT VALUES ('ENG', 'Engineering and Performance');
INSERT INTO DEPARTMENT VALUES ('HR', 'Human Resources and Scheduling');
INSERT INTO DEPARTMENT VALUES ('PIT', 'Pit Crew Operations');

-- EMPLOYEE
INSERT INTO EMPLOYEE VALUES (1, 'LOG', 'Graham', 'Robert', DATE '2004-05-12', '0711111111', 'graham@nwu.ac.za', 'M', 'Logistics Staff');
INSERT INTO EMPLOYEE VALUES (2, 'BUS', 'Tjay', 'Burger', DATE '2004-08-20', '0722222222', 'tjay@nwu.ac.za', 'M', 'Business Administrator');
INSERT INTO EMPLOYEE VALUES (3, 'ENG', 'Wihan', 'Jacobsz', DATE '2004-03-15', '0733333333', 'wihan@nwu.ac.za', 'M', 'Engineer');
INSERT INTO EMPLOYEE VALUES (4, 'HR', 'Stephan', 'van Rensburg', DATE '2004-11-04', '0744444444', 'stephan@nwu.ac.za', 'M', 'HR Scheduler');
INSERT INTO EMPLOYEE VALUES (5, 'PIT', 'Ruben', 'Badenhorst', DATE '2004-07-22', '0755555555', 'ruben@nwu.ac.za', 'M', 'Mechanic');

-- SPONSOR
INSERT INTO SPONSOR VALUES (1, 'Oracle');
INSERT INTO SPONSOR VALUES (2, 'Red Bull');
INSERT INTO SPONSOR VALUES (3, 'Pirelli');
INSERT INTO SPONSOR VALUES (4, 'Petronas');
INSERT INTO SPONSOR VALUES (5, 'Dell Technologies');

-- CONTRACT
INSERT INTO CONTRACT VALUES (1, '2026 Season', 'Primary sponsorship agreement', DATE '2026-01-10');
INSERT INTO CONTRACT VALUES (2, '2026 Season', 'Technical partnership agreement', DATE '2026-01-15');
INSERT INTO CONTRACT VALUES (3, '2026 Season', 'Tyre supply partnership agreement', DATE '2026-01-20');
INSERT INTO CONTRACT VALUES (4, '2026 Season', 'Driver salary agreement', DATE '2026-02-01');
INSERT INTO CONTRACT VALUES (5, '2026 Season', 'IT infrastructure support agreement', DATE '2026-02-05');

-- CIRCUIT
INSERT INTO CIRCUIT VALUES (1, 'Monaco', 'CET');
INSERT INTO CIRCUIT VALUES (2, 'Silverstone', 'GMT');
INSERT INTO CIRCUIT VALUES (3, 'Spa-Francorchamps', 'CET');
INSERT INTO CIRCUIT VALUES (4, 'Monza', 'CET');
INSERT INTO CIRCUIT VALUES (5, 'Suzuka', 'JST');

-- SEASON
INSERT INTO SEASON VALUES (1, 2026);
INSERT INTO SEASON VALUES (2, 2025);
INSERT INTO SEASON VALUES (3, 2024);

COMMIT;
