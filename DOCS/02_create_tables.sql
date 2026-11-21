
USE AssetManagementDB;
GO

-- =========================================
-- STEP 1: DROP EXISTING TABLES
-- Child tables must be dropped first
-- =========================================

DROP TABLE IF EXISTS dbo.Maintenance;
DROP TABLE IF EXISTS dbo.Allocations;
DROP TABLE IF EXISTS dbo.Assets;
DROP TABLE IF EXISTS dbo.Employees;
DROP TABLE IF EXISTS dbo.Vendors;
DROP TABLE IF EXISTS dbo.Locations;
DROP TABLE IF EXISTS dbo.Categories;
DROP TABLE IF EXISTS dbo.Departments;
GO

-- =========================================
-- STEP 2: DEPARTMENTS
-- =========================================

CREATE TABLE dbo.Departments
(
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
GO

-- =========================================
-- STEP 3: EMPLOYEES
-- =========================================

CREATE TABLE dbo.Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(150) NOT NULL UNIQUE,
    Phone NVARCHAR(15),

    DepartmentID INT NOT NULL,

    CONSTRAINT FK_Employees_Departments
    FOREIGN KEY (DepartmentID)
    REFERENCES dbo.Departments(DepartmentID)
);
GO

-- =========================================
-- STEP 4: CATEGORIES
-- =========================================

CREATE TABLE dbo.Categories
(
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255)
);
GO

-- =========================================
-- STEP 5: LOCATIONS
-- =========================================

CREATE TABLE dbo.Locations
(
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    LocationName NVARCHAR(100) NOT NULL UNIQUE,
    Building NVARCHAR(100),
    Floor NVARCHAR(30),
    RoomNumber NVARCHAR(30)
);
GO

-- =========================================
-- STEP 6: VENDORS
-- =========================================

CREATE TABLE dbo.Vendors
(
    VendorID INT IDENTITY(1,1) PRIMARY KEY,
    VendorName NVARCHAR(150) NOT NULL,
    ContactPerson NVARCHAR(100),
    Email NVARCHAR(150),
    Phone NVARCHAR(15),
    Address NVARCHAR(255)
);
GO

-- =========================================
-- STEP 7: ASSETS
-- =========================================

CREATE TABLE dbo.Assets
(
    AssetID INT IDENTITY(1,1) PRIMARY KEY,
    AssetTag NVARCHAR(50) NOT NULL UNIQUE,
    AssetName NVARCHAR(150) NOT NULL,
    SerialNumber NVARCHAR(100),

    CategoryID INT NOT NULL,
    LocationID INT NOT NULL,
    VendorID INT NULL,

    PurchaseDate DATE NOT NULL,
    PurchaseCost DECIMAL(12,2) NOT NULL,
    WarrantyExpiryDate DATE,

    AssetStatus NVARCHAR(30) NOT NULL
        DEFAULT 'Available',

    CONSTRAINT CK_Assets_PurchaseCost
    CHECK (PurchaseCost >= 0),

    CONSTRAINT CK_Assets_Status
    CHECK (AssetStatus IN
    ('Available', 'Assigned', 'Under Maintenance', 'Retired')),

    CONSTRAINT FK_Assets_Categories
    FOREIGN KEY (CategoryID)
    REFERENCES dbo.Categories(CategoryID),

    CONSTRAINT FK_Assets_Locations
    FOREIGN KEY (LocationID)
    REFERENCES dbo.Locations(LocationID),

    CONSTRAINT FK_Assets_Vendors
    FOREIGN KEY (VendorID)
    REFERENCES dbo.Vendors(VendorID)
);
GO

-- =========================================
-- STEP 8: ALLOCATIONS
-- =========================================

CREATE TABLE dbo.Allocations
(
    AllocationID INT IDENTITY(1,1) PRIMARY KEY,

    AssetID INT NOT NULL,
    EmployeeID INT NOT NULL,

    AllocatedDate DATE NOT NULL,
    ReturnedDate DATE,

    AllocationStatus NVARCHAR(20) NOT NULL
        DEFAULT 'Active',

    Notes NVARCHAR(255),

    CONSTRAINT CK_Allocations_Status
    CHECK (AllocationStatus IN ('Active', 'Returned')),

    CONSTRAINT CK_Allocations_ReturnDate
    CHECK (ReturnedDate IS NULL OR ReturnedDate >= AllocatedDate),

    CONSTRAINT FK_Allocations_Assets
    FOREIGN KEY (AssetID)
    REFERENCES dbo.Assets(AssetID),

    CONSTRAINT FK_Allocations_Employees
    FOREIGN KEY (EmployeeID)
    REFERENCES dbo.Employees(EmployeeID)
);
GO

-- =========================================
-- STEP 9: MAINTENANCE
-- =========================================

CREATE TABLE dbo.Maintenance
(
    MaintenanceID INT IDENTITY(1,1) PRIMARY KEY,

    AssetID INT NOT NULL,
    ReportedByEmployeeID INT NULL,
    VendorID INT NULL,

    IssueDescription NVARCHAR(500) NOT NULL,
    RequestDate DATE NOT NULL,
    CompletionDate DATE,

    MaintenanceCost DECIMAL(12,2) NOT NULL DEFAULT 0,

    MaintenanceStatus NVARCHAR(30) NOT NULL
        DEFAULT 'Open',

    CONSTRAINT CK_Maintenance_Cost
    CHECK (MaintenanceCost >= 0),

    CONSTRAINT CK_Maintenance_Status
    CHECK (MaintenanceStatus IN
    ('Open', 'In Progress', 'Completed', 'Cancelled')),

    CONSTRAINT FK_Maintenance_Assets
    FOREIGN KEY (AssetID)
    REFERENCES dbo.Assets(AssetID),

    CONSTRAINT FK_Maintenance_Employees
    FOREIGN KEY (ReportedByEmployeeID)
    REFERENCES dbo.Employees(EmployeeID),

    CONSTRAINT FK_Maintenance_Vendors
    FOREIGN KEY (VendorID)
    REFERENCES dbo.Vendors(VendorID)
);
GO

-- =========================================
-- STEP 10: VERIFY ALL TABLES
-- =========================================

SELECT name AS TableName
FROM sys.tables
ORDER BY name;
GO
