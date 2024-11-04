-- Kompression

-- Daten verkleinern
--> Weniger Daten werden geladen, mehr CPU leistung verwenden

-- Zwei verschiedene Typen
-- Row Compression: 
-- Page Compression


USE Northwind;
SELECT  Orders.OrderDate, Orders.RequiredDate, Orders.ShippedDate, Orders.Freight, Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.Address, Customers.City, 
        Customers.Region, Customers.PostalCode, Customers.Country, Customers.Phone, Orders.OrderID, Employees.EmployeeID, Employees.LastName, Employees.FirstName, Employees.Title, [Order Details].UnitPrice, 
        [Order Details].Quantity, [Order Details].Discount, Products.ProductID, Products.ProductName, Products.UnitsInStock
INTO SchlechteDemo.dbo.M004_Kompression
FROM    [Order Details] INNER JOIN
        Products ON Products.ProductID = [Order Details].ProductID INNER JOIN
        Orders ON [Order Details].OrderID = Orders.OrderID INNER JOIN
        Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
        Customers ON Orders.CustomerID = Customers.CustomerID

USE SchlechteDemo

INSERT INTO M004_Kompression
SELECT * FROM M004_Kompression
GO 8

SELECT COUNT(*) FROM M004_Kompression

SET STATISTICS time, IO ON

-- Ohne Compression: logische Lesevorgänge: 28246
-- CPU-Zeit: 1250ms, verstrichene Zeit: 9548ms
SELECT * FROM M004_Kompression

-- Row Compression
USE [SchlechteDemo]
ALTER TABLE [dbo].[M004_Kompression] REBUILD PARTITION = ALL
WITH
(DATA_COMPRESSION = ROW
)

-- Row Compression: logische Lesevorgänge: 15797
-- CPU-Zeit: 2453ms, verstrichene Zeit: 11000ms
SELECT * FROM M004_Kompression

-- Page Compression
USE [SchlechteDemo]
ALTER TABLE [dbo].[M004_Kompression] REBUILD PARTITION = ALL
WITH
(DATA_COMPRESSION = PAGE
)

-- Page Compression: logische Lesevorgänge: 7523
-- CPU-Zeit: 3564ms, verstrichene Zeit: 10567ms
SELECT * FROM M004_Kompression

-- Partition können auch komprimiert werden
SELECT OBJECT_NAME(OBJECT_ID), * FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')
WHERE compressed_page_count != 0

-- Alle Kompressionen ausgeben
SELECT t.name as TableName, p.partition_number as PartitionNumber, p.data_compression_desc AS Compression
FROM sys.partitions as P
JOIN sys.tables as t on t.object_id = p.object_id
