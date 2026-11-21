USE MASTER;
GO
if exists (select 1 from sys.databases WHERE name = 'AssetManagementDB')
BEGIN
    ALTER DATABASE AssetManagementDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AssetManagementDB;
END;
go
CREATE DATABASE AssetManagementDB;
GO
