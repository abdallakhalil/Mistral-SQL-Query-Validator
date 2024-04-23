-- Create the 'Producer' table for producer data
CREATE TABLE Producer (
    Vineyard VARCHAR(255) PRIMARY KEY, -- 'Vineyard' column as primary key, uniquely identifies each producer
    Area VARCHAR(255), -- 'Area' column for the name of the area where the vineyard is located
    Region VARCHAR(255) -- 'Region' column for the name of the region where the area is located
);

-- Create the 'Wine' table for wine data
CREATE TABLE Wine (
    Name VARCHAR(255) PRIMARY KEY, -- 'Name' column as primary key, uniquely identifies each wine
    Color VARCHAR(255), -- 'Color' column for the color of the wine
    Year INT, -- 'Year' column for the year the wine was produced
    Vineyard VARCHAR(255), -- 'Vineyard' column, refers to the vineyard in the 'Producer' table
    FOREIGN KEY (Vineyard) REFERENCES Producer(Vineyard) -- Foreign key relationship, 'Vineyard' in 'Wine' references 'Vineyard' in 'Producer'
);


-- Creating a table to store student information
CREATE TABLE student(
    StudentID char(6) NOT NULL,       -- Unique identifier for each student, cannot be null
    Firstname varchar(20) NOT NULL,   -- Student's first name, cannot be null
    Lastname varchar(20) NOT NULL,    -- Student's last name, cannot be null
    Course varchar(20),               -- The course the student is enrolled in
    PRIMARY KEY (StudentID)           -- Setting StudentID as the primary key for the table
);

-- Creating a table to store restaurant information
CREATE TABLE restaurant(
    name varchar(20) NOT NULL,        -- Name of the restaurant, cannot be null and acts as a unique identifier
    owner varchar(20),                -- Owner of the restaurant
    zip char(5) NOT NULL,             -- Postal code where the restaurant is located, cannot be null
    city varchar(20) NOT NULL,        -- City where the restaurant is located, cannot be null
    street varchar(20) NOT NULL,      -- Street address of the restaurant, cannot be null
    PRIMARY KEY (name)                -- Setting the name as the primary key for the table
);


-- Creating a table to store the relationships between students and restaurants
CREATE TABLE student_restaurant(
    StudentID char(6) NOT NULL,       -- Student identifier, cannot be null, references a student
    name varchar(20) NOT NULL,        -- Restaurant name, cannot be null, references a restaurant
    PRIMARY KEY (StudentID, name),    -- Composite primary key consisting of StudentID and restaurant name to ensure unique records
    FOREIGN KEY (StudentID) REFERENCES student(StudentID), -- Foreign key constraint, StudentID must exist in the student table
    FOREIGN KEY (name) REFERENCES restaurant(name)         -- Foreign key constraint, restaurant name must exist in the restaurant table
);

-- Creating a table to store recommendations of wines by critics
CREATE TABLE recommends (
    wname varchar(20) NOT NULL,        -- Wine name, cannot be null
    gname varchar(20) NOT NULL,        -- Grape name, cannot be null
    cname varchar(20) NOT NULL,        -- Critic name, cannot be null
    PRIMARY KEY (wname, gname, cname), -- Composite primary key to ensure unique recommendations
    FOREIGN KEY (wname) REFERENCES wine(name) -- Foreign key constraint, wine name must exist in the wine table
    ON UPDATE CASCADE,                 -- On update of wine name in wine table, corresponding records here will be updated
    FOREIGN KEY (gname) REFERENCES grape(name) -- Foreign key constraint, grape name must exist in the grape table
    ON UPDATE CASCADE,                 -- On update of grape name in grape table, corresponding records here will be updated
    FOREIGN KEY (cname) REFERENCES critic(name) -- Foreign key constraint, critic name must exist in the critic table
    ON UPDATE CASCADE                  -- On update of critic name in critic table, corresponding records here will be updated
);

-- Creating a table to store information on which grapes are used to make wines and in what proportion
CREATE TABLE made_from (
    wname varchar(20) NOT NULL,        -- Wine name, cannot be null
    gname varchar(20) NOT NULL,        -- Grape name, cannot be null
    proportion decimal(3,1) NOT NULL,  -- Proportion of the grape used in the wine, cannot be null
    PRIMARY KEY (wname, gname),        -- Composite primary key to ensure unique combinations of wine and grape
    FOREIGN KEY (wname) REFERENCES wine(name) -- Foreign key constraint, wine name must exist in the wine table
    ON UPDATE CASCADE,                 -- On update of wine name in wine table, corresponding records here will be updated
    FOREIGN KEY (gname) REFERENCES grape(name) -- Foreign key constraint, grape name must exist in the grape table
    ON UPDATE CASCADE                  -- On update of grape name in grape table, corresponding records here will be updated
);

-- Grape entity
CREATE TABLE Grape (
    Name VARCHAR(255) PRIMARY KEY, -- Primary key uniquely identifies each grape
    Color VARCHAR(255) -- Color of the grape
);

-- Flight entity table stores details of flights
CREATE TABLE flight (
    label VARCHAR(255) PRIMARY KEY, -- Unique flight identifier
    date DATE NOT NULL, -- Date of the flight
    destination VARCHAR(255) NOT NULL, -- Destination of the flight
    flight_time TIME NOT NULL, -- Duration of the flight
    distance INT NOT NULL -- Distance covered by the flight
);

-- Departure relationship table stores the association between flights, planes, and captains
CREATE TABLE departure (
    flight_label VARCHAR(255), -- Flight identifier, foreign key to flight table
    flight_date DATE, -- Date of the flight, foreign key to flight table
    type VARCHAR(255), -- Type of plane, foreign key to plane table
    serial_number INT, -- Serial number of plane, foreign key to plane table
    captain_id INT, -- Identifier for the captain (employee), foreign key to employee table
    PRIMARY KEY (flight_label, flight_date), -- Composite key to uniquely identify a departure
    FOREIGN KEY (flight_label, flight_date) REFERENCES flight(label, date), -- References flight table
    FOREIGN KEY (type, serial_number) REFERENCES plane(type, serial_number), -- References plane table
    FOREIGN KEY (captain_id) REFERENCES employee(ID) -- References employee table
);

-- Employee entity table stores details of airline employees
CREATE TABLE employee (
    ID INT PRIMARY KEY, -- Unique identifier for an employee
    name VARCHAR(255) NOT NULL, -- Name of the employee
    address VARCHAR(255) NOT NULL, -- Address of the employee
    job VARCHAR(255) NOT NULL, -- Job title of the employee
    salary DECIMAL(10,2) NOT NULL -- Salary of the employee
);

-- Plane type entity table stores different types of planes
CREATE TABLE plane_type (
    type VARCHAR(255) PRIMARY KEY, -- Unique type of the plane
    manufacturer VARCHAR(255) NOT NULL, -- Manufacturer of the plane
    number_of_seats INT NOT NULL, -- Number of seats available on the plane
    cruising_speed INT NOT NULL -- Cruising speed of the plane
);

-- Plane entity table stores individual planes
CREATE TABLE plane (
    type VARCHAR(255), -- Type of the plane, foreign key to plane_type table
    serial_number INT, -- Unique serial number of the plane
    purchase_date DATE NOT NULL, -- Date of purchase of the plane
    flight_hours INT NOT NULL, -- Accumulated flight hours of the plane
    PRIMARY KEY (type, serial_number), -- Composite key to uniquely identify a plane
    FOREIGN KEY (type) REFERENCES plane_type(type) -- References plane_type table
);

-- Spare part entity table stores details of spare parts
CREATE TABLE spare_part (
    ID INT PRIMARY KEY, -- Unique identifier for a spare part
    label VARCHAR(255) NOT NULL, -- Label or name of the spare part
    price DECIMAL(10,2) NOT NULL -- Price of the spare part
);

-- Requires relationship table stores which planes require which spare parts
CREATE TABLE requires (
    type VARCHAR(255), -- Type of plane, foreign key to plane table
    serial_number INT, -- Serial number of plane, foreign key to plane table
    spare_part_ID INT, -- ID of the spare part, foreign key to spare_part table
    PRIMARY KEY (type, serial_number, spare_part_ID), -- Composite key to uniquely identify a requirement
    FOREIGN KEY (type, serial_number) REFERENCES plane(type, serial_number), -- References plane table
    FOREIGN KEY (spare_part_ID) REFERENCES spare_part(ID) -- References spare_part table
);

-- Pilot specialization table stores details of pilots
CREATE TABLE pilot (
    employee_ID INT PRIMARY KEY, -- Employee ID of the pilot, foreign key to employee table
    license VARCHAR(255) NOT NULL, -- Pilot's flying license
    flight_hours INT NOT NULL, -- Accumulated flight hours of the pilot
    FOREIGN KEY (employee_ID) REFERENCES employee(ID) -- References employee table
);

-- Technician specialization table stores details of technicians
CREATE TABLE technician (
    employee_ID INT PRIMARY KEY, -- Employee ID of the technician, foreign key to employee table
    team_number INT NOT NULL, -- Team number that the technician belongs to
    FOREIGN KEY (employee_ID) REFERENCES employee(ID) -- References employee table
);

-- Can fly relationship table stores which pilots can fly which plane types
CREATE TABLE can_fly (
    employee_ID INT, -- Employee ID of the pilot, foreign key to pilot table
    type VARCHAR(255), -- Type of plane, foreign key to plane_type table
    PRIMARY KEY (employee_ID, type), -- Composite key to uniquely identify the capability
    FOREIGN KEY (employee_ID) REFERENCES pilot(employee_ID), -- References pilot table
    FOREIGN KEY (type) REFERENCES plane_type(type) -- References plane_type table for valid plane types a pilot can fly
);

-- Can maintain relationship table stores which technicians can maintain which plane types
CREATE TABLE can_maintain (
    employee_ID INT, -- Employee ID of the technician, foreign key to technician table
    type VARCHAR(255), -- Type of plane, foreign key to plane_type table
    PRIMARY KEY (employee_ID, type), -- Composite key to uniquely identify maintenance capability
    FOREIGN KEY (employee_ID) REFERENCES technician(employee_ID), -- References technician table
    FOREIGN KEY (type) REFERENCES plane_type(type) -- References plane_type table for valid plane types a technician can maintain
);

-- Passenger entity table stores details of passengers
CREATE TABLE passenger (
    passenger_ID INT PRIMARY KEY, -- Unique identifier for a passenger
    name VARCHAR(255) NOT NULL, -- Name of the passenger
    address VARCHAR(255) NOT NULL, -- Address of the passenger
    age INT NOT NULL -- Age of the passenger
);

-- Booking relationship table stores data about bookings made by passengers
CREATE TABLE booking (
    passenger_ID INT, -- Passenger ID, foreign key to passenger table
    flight_label VARCHAR(255), -- Flight label, foreign key to flight table
    flight_date DATE, -- Date of the flight, foreign key to flight table
    class VARCHAR(255) NOT NULL, -- Class of the booking (e.g., economy, business)
    seat_number INT NOT NULL, -- Seat number allocated to the passenger
    price DECIMAL(10,2) NOT NULL, -- Price of the booking
    PRIMARY KEY (passenger_ID, flight_label, flight_date), -- Composite key to uniquely identify a booking
    FOREIGN KEY (passenger_ID) REFERENCES passenger(passenger_ID), -- References passenger table
    FOREIGN KEY (flight_label, flight_date) REFERENCES flight(label, date) -- References flight table for the specific flight
);

SELECT DISTINCT X.exam_id   -- Selects unique exam IDs to avoid duplicates in results
FROM exams X                -- From the 'exams' table aliased as 'X'
WHERE X.exam_id IN (        -- Filters for exams where the ID is in the list returned by the subquery
    SELECT Y.exam_id        -- Selects exam IDs from the 'exams' table in the subquery
    FROM exams Y            -- From the 'exams' table aliased as 'Y' for the subquery
    WHERE Y.student_id <> X.student_id  -- Where the student ID from 'Y' is different than that from 'X'
);

-- Customer table stores customer information
CREATE TABLE Customer (
    Cid INT PRIMARY KEY, -- Customer ID as primary key
    Name VARCHAR(255) NOT NULL -- Name of the customer
);

-- Dealer table stores dealer information
CREATE TABLE Dealer (
    Did INT PRIMARY KEY, -- Dealer ID as primary key
    Name VARCHAR(255) NOT NULL -- Name of the dealer
);

-- Product table stores product details
CREATE TABLE Product (
    Pid INT PRIMARY KEY, -- Product ID as primary key
    Label VARCHAR(255) NOT NULL -- Label or name of the product
);

-- Offers table links dealers with products they offer
CREATE TABLE Offers (
    Did INT, -- Dealer ID from Dealer table
    Pid INT, -- Product ID from Product table
    PRIMARY KEY (Did, Pid), -- Composite primary key to ensure unique pairs
    FOREIGN KEY (Did) REFERENCES Dealer(Did), -- Foreign key to Dealer table
    FOREIGN KEY (Pid) REFERENCES Product(Pid) -- Foreign key to Product table
);

-- Orders table stores information about orders placed by customers through dealers
CREATE TABLE Orders (
    Oid INT PRIMARY KEY, -- Order ID as primary key
    Did INT, -- Dealer ID from Dealer table
    Date DATE NOT NULL, -- Date the order was placed
    Cid INT, -- Customer ID from Customer table
    FOREIGN KEY (Did) REFERENCES Dealer(Did), -- Foreign key to Dealer table
    FOREIGN KEY (Cid) REFERENCES Customer(Cid) -- Foreign key to Customer table
);

-- Line Item table stores details about products within each order
CREATE TABLE Line_Item (
    Oid INT, -- Order ID from Orders table
    Pid INT, -- Product ID from Product table
    Amount INT NOT NULL, -- Quantity of the product ordered
    PRIMARY KEY (Oid, Pid), -- Composite primary key to ensure unique pairs
    FOREIGN KEY (Oid) REFERENCES Orders(Oid), -- Foreign key to Orders table
    FOREIGN KEY (Pid) REFERENCES Product(Pid) -- Foreign key to Product table
);

CREATE TABLE Exams (
    CourseOfStudies VARCHAR(255) NOT NULL, -- The field of study or department
    Course VARCHAR(255) NOT NULL, -- Specific course name or identifier
    Student VARCHAR(255) NOT NULL, -- Name or identifier of the student
    Examiner VARCHAR(255) NOT NULL, -- Name or identifier of the examiner
    ExamDate DATE NOT NULL, -- The date when the exam took place
    Mark INT -- The mark or grade received in the exam
);

-- (a) Creating a view 'fac_inf' for all Informatics (Computer Science) exams
CREATE VIEW fac_inf AS
SELECT *
FROM exams
WHERE course_of_studies = 'INF'; -- Filters exams for the Informatics (INF) course of studies

-- (b) Creating a view 'examOffice' for the examination office to see all exams
CREATE VIEW examOffice AS
SELECT * 
FROM exams; -- Selects all columns from the exams table without any filter

-- (c) Creating a view 'scholCom' for the scholarship committee showing average marks
CREATE VIEW scholCom AS
SELECT student, AVG(mark) AS average_mark -- Calculates the average mark for each student
FROM exams
GROUP BY student; -- Groups the results by student to calculate each student's average mark

-- (d) Creating a view 'dean' for the dean's office to see recent exams within the past year
CREATE VIEW dean AS
SELECT course_of_studies, course, date, mark
FROM exams
WHERE DATEDIFF(NOW(), date) < 365 -- Selects exams where the date is within the last 365 days from today
GROUP BY course_of_studies, course, date, mark; -- Groups the results by course of studies, course, date, and mark

-- Alternatively, using EXTRACT to create a view 'dean_alternative' for the current year's exams
CREATE VIEW dean_alternative AS
SELECT course_of_studies, course, date, mark
FROM exams
WHERE EXTRACT(YEAR FROM date) = EXTRACT(YEAR FROM NOW()) -- Selects exams from the current year
GROUP BY course_of_studies, course, date, mark; -- Groups the results by course of studies, course, date, and mark

CREATE TABLE Orders (
    Oid INT PRIMARY KEY, -- 'Oid' is the primary key for the Orders table, uniquely identifying each order.
    Did INT REFERENCES Dealer(Did), -- 'Did' is a foreign key that references the 'Did' primary key in the Dealer table.
    Date DATE DEFAULT (CURRENT_DATE()), -- 'Date' is the date of the order with a default value set to the current date.
    Cid INT REFERENCES Customer(Cid) -- 'Cid' is a foreign key that references the 'Cid' primary key in the Customer table.
);

SELECT *                              -- Selects all columns from both Customer and Product tables
FROM Customer, Product                -- Cross join of Customer and Product tables
WHERE (Cid, Name, Pid, Label) NOT IN ( -- Filter to exclude rows where the combination of these columns
    SELECT Customer.Cid,              -- Selects the Customer ID from the Customer table
           Customer.Name,             -- Selects the Customer Name from the Customer table
           Product.Pid,               -- Selects the Product ID from the Product table
           Product.Label              -- Selects the Product Label from the Product table
    FROM Customer                     -- From the Customer table
    NATURAL JOIN Orders               -- NATURAL JOIN automatically matches columns between Customer and Orders tables with the same names
    NATURAL JOIN line_item            -- NATURAL JOIN automatically matches columns between Orders and line_item tables with the same names
    NATURAL JOIN Product              -- NATURAL JOIN automatically matches columns between line_item and Product tables with the same names
);

SELECT C1.Name, C2.Name       -- Selects the names of two different customers
FROM Customer C1, Customer C2, Orders O1, Orders O2, line_item P1, line_item P2  -- From the Customer, Orders, and line_item tables, with aliases for each
WHERE C1.Cid = O1.Cid         -- Links the first customer alias (C1) to their orders (O1)
AND O1.Oid = P1.Oid           -- Links the first order alias (O1) to its line items (P1)
AND C2.Cid = O2.Cid           -- Links the second customer alias (C2) to their orders (O2)
AND O2.Oid = P2.Oid           -- Links the second order alias (O2) to its line items (P2)
AND P1.Pid = P2.Pid           -- Ensures that the line items from the first and second orders are for the same product
AND C1.Cid < C2.Cid;          -- Ensures that the pair of customers (C1 and C2) are not the same and avoids duplicate pairs in reverse order


SELECT Did                    -- Selects dealer IDs
FROM Dealer                   -- From the Dealer table
WHERE Did NOT IN (            -- Filters out dealers that are present in the subquery
    SELECT Dealer.Did         -- Selects dealer IDs from the Dealer table in the subquery
    FROM Dealer
    JOIN line_item ON Dealer.Did = line_item.Did -- Joins the Dealer table with the line_item table on the dealer ID
    WHERE (Dealer.Did, line_item.Pid) NOT IN ( -- Filters for dealer and product ID combinations that are not in the offers table
        SELECT Did, Pid     -- Selects dealer IDs and product IDs
        FROM offers         -- From the offers table
    )
);

SELECT Did                         -- Select dealer IDs
FROM Dealer                        -- From the Dealer table
WHERE Did NOT IN (                 -- Exclude dealers who meet the following criteria
    SELECT Dealer.Did              -- Select dealer IDs from the Dealer table
    FROM line_item
    JOIN Orders ON line_item.Oid = Orders.Oid   -- Join line_item with Orders based on Order ID
    JOIN Customer ON Orders.Cid = Customer.Cid  -- Join Orders with Customer based on Customer ID
    JOIN Dealer ON line_item.Did = Dealer.Did   -- Join line_item with Dealer based on Dealer ID
    WHERE Customer.Name = 'I. Schulze'          -- Filter orders made by customer 'I. Schulze'
    AND (Dealer.Did, line_item.Pid) NOT IN (    -- Further filter for dealers who have not offered certain products
        SELECT Did, Pid                         -- Select dealer IDs and product IDs
        FROM offers                             -- From the offers table
    )
);


