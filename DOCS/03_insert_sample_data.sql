
USE AssetManagementDB;
GO

-- =========================================
-- STEP 1: CLEAR EXISTING DATA
-- Delete child records before parent records
-- =========================================

DELETE FROM dbo.Maintenance;
DELETE FROM dbo.Allocations;
DELETE FROM dbo.Assets;
DELETE FROM dbo.Employees;
DELETE FROM dbo.Vendors;
DELETE FROM dbo.Locations;
DELETE FROM dbo.Categories;
DELETE FROM dbo.Departments;
GO

-- =========================================
-- STEP 2: RESET IDENTITY COUNTERS
-- =========================================

DBCC CHECKIDENT ('Departments', RESEED, 0);
DBCC CHECKIDENT ('Categories', RESEED, 0);
DBCC CHECKIDENT ('Locations', RESEED, 0);
DBCC CHECKIDENT ('Vendors', RESEED, 0);

DBCC CHECKIDENT ('Employees', RESEED, 1);
DBCC CHECKIDENT ('Assets', RESEED, 1);

DBCC CHECKIDENT ('Allocations', RESEED, 1);
DBCC CHECKIDENT ('Maintenance', RESEED, 1);
GO
-- =========================================
-- STEP 3: INSERT DEPARTMENTS
-- =========================================

INSERT INTO dbo.Departments
(DepartmentName, Description)
VALUES
('IT', 'Information Technology'),
('HR', 'Human Resources'),
('Finance', 'Finance Department'),
('Operations', 'Operations Department');
GO

-- =========================================
-- STEP 4: INSERT EMPLOYEES
-- =========================================

INSERT INTO dbo.Employees
(FirstName, LastName, Email, Phone, DepartmentID)
VALUES
('Rahul', 'Sharma', 'rahul@gmail.com', '9876543210', 1),
('Priya', 'Das', 'priya@gmail.com', '9876543211', 1),
('Amit', 'Kumar', 'amit@gmail.com', '9876543212', 2),
('Sneha', 'Patel', 'sneha@gmail.com', '9876543213', 3),
('Rohit', 'Sahu', 'rohit@gmail.com', '9876543214', 4);
GO

-- =========================================
-- STEP 5: INSERT CATEGORIES
-- =========================================

INSERT INTO dbo.Categories
(CategoryName, Description)
VALUES
('Laptop', 'Portable computing devices'),
('Monitor', 'Computer display devices'),
('Printer', 'Printing equipment'),
('Networking', 'Network infrastructure equipment'),
('Accessories', 'Computer accessories');
GO

-- =========================================
-- STEP 6: INSERT LOCATIONS
-- =========================================

INSERT INTO dbo.Locations
(LocationName, Building, Floor, RoomNumber)
VALUES
('IT Office', 'Main Building', 'First Floor', '101'),
('HR Office', 'Main Building', 'Second Floor', '201'),
('Server Room', 'Technical Building', 'Ground Floor', 'G01');
GO

-- =========================================
-- STEP 7: INSERT VENDORS
-- =========================================

INSERT INTO dbo.Vendors
(VendorName, ContactPerson, Email, Phone, Address)
VALUES
('Dell Technologies', 'Arun Das', 'dell@example.com', '9000000001', 'Bhubaneswar'),
('HP India', 'Rakesh Kumar', 'hp@example.com', '9000000002', 'Cuttack'),
('Tech Solutions', 'Sanjay Sahu', 'tech@example.com', '9000000003', 'Bhubaneswar');
GO

-- =========================================
-- STEP 8: INSERT ASSETS
-- =========================================

INSERT INTO dbo.Assets
(
    AssetTag, AssetName, SerialNumber,
    CategoryID, LocationID, VendorID,
    PurchaseDate, PurchaseCost, WarrantyExpiryDate,
    AssetStatus
)
VALUES
('AST-1001', 'Dell Latitude Laptop', 'DL10001',
 1, 1, 1, '2025-01-15', 72000, '2028-01-14', 'Assigned'),

('AST-1002', 'HP ProBook Laptop', 'HP10002',
 1, 1, 2, '2025-02-10', 68000, '2028-02-09', 'Assigned'),

('AST-1003', 'Dell 24 Inch Monitor', 'DM10003',
 2, 2, 1, '2024-08-20', 15000, '2027-08-19', 'Available'),

('AST-1004', 'HP LaserJet Printer', 'HP10004',
 3, 2, 2, '2024-05-11', 28000, '2026-05-10', 'Under Maintenance'),

('AST-1005', 'Cisco Network Switch', 'CS10005',
 4, 3, 3, '2025-03-02', 45000, '2028-03-01', 'Available'),

('AST-1006', 'Logitech Webcam', 'LG10006',
 5, 1, 3, '2025-04-05', 6500, '2027-04-04', 'Available');
GO

-- =========================================
-- STEP 9: INSERT ALLOCATIONS
-- =========================================

INSERT INTO dbo.Allocations
(AssetID, EmployeeID, AllocatedDate, ReturnedDate, AllocationStatus, Notes)
VALUES
(1, 1, '2025-02-01', NULL, 'Active', 'Laptop assigned to Rahul'),

(2, 2, '2025-02-15', NULL, 'Active', 'Laptop assigned to Priya'),

(3, 3, '2024-09-01', '2025-01-15', 'Returned', 'Monitor returned by Amit');
GO

-- =========================================
-- STEP 10: INSERT MAINTENANCE RECORDS
-- =========================================

INSERT INTO dbo.Maintenance
(
    AssetID, ReportedByEmployeeID, VendorID,
    IssueDescription, RequestDate, CompletionDate,
    MaintenanceCost, MaintenanceStatus
)
VALUES
(4, 3, 2,
 'Printer paper feeding issue',
 '2025-05-10', NULL, 0, 'In Progress'),

(1, 1, 1,
 'Laptop keyboard replacement',
 '2025-03-10', '2025-03-12', 2500, 'Completed');
GO

-- =========================================
-- STEP 11: VERIFY ALL TABLES
-- =========================================

SELECT * FROM dbo.Departments;
SELECT * FROM dbo.Employees;
SELECT * FROM dbo.Categories;
SELECT * FROM dbo.Locations;
SELECT * FROM dbo.Vendors;
SELECT * FROM dbo.Assets;
SELECT * FROM dbo.Allocations;
SELECT * FROM dbo.Maintenance;
GO
