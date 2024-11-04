-- Varianten
--> Country varchar(20)
CREATE PROCEDURE sp_KundenTest1
@CustomerID char(5), @CompanyName varchar(40),
@Country varchar(20), @City varchar(30)
AS
INSERT INTO Customers (CustomerID, CompanyName, Country, City)
VALUES (@CustomerID, @CompanyName, @Country, @City)
GO

EXEC sp_KundenTest1 '54321', 'ppedv Ag', 'GermanyGermanyGermany123', 'Berlin'
GO
SELECT * FROM Customers

-- Versuch Nr.2
-- Default Wert muss größer als 20 Charakter sein
CREATE PROCEDURE sp_KundenTest2
@CustomerID char(5) = '54321', @CompanyName varchar(40) = 'Hallo123',
@Country varchar(20) = 'GermanyGermanyGermanyGermany', @City varchar(30) = 'Berlin'
AS
INSERT INTO Customers (CustomerID, CompanyName, Country, City)
VALUES (@CustomerID, @CompanyName, @Country, @City)
GO

EXEC sp_KundenTest2

-- Versuch Nr.3
-- Varianten
--> Country varchar(10)
CREATE PROCEDURE sp_KundenTest3
@CustomerID char(5), @CompanyName varchar(40),
@Country varchar(10), @City varchar(30)
AS
INSERT INTO Customers (CustomerID, CompanyName, Country, City)
VALUES (@CustomerID, @CompanyName, @Country, @City)
GO

EXEC sp_KundenTest3 '54321', 'ppedv Ag', 'GermanyGermanyGermany123', 'Berlin'
SELECT * FROM Customers


-- Versuch Nr.4
-- Default Wert muss größer als 10 Charakter sein
CREATE PROCEDURE sp_KundenTest4
@CustomerID char(5) = '98765', @CompanyName varchar(40) = 'Hallo123',
@Country varchar(10) = 'GermanyGermanyGermanyGermany', @City varchar(30) = 'Berlin'
AS
INSERT INTO Customers (CustomerID, CompanyName, Country, City)
VALUES (@CustomerID, @CompanyName, @Country, @City)
GO

EXEC sp_KundenTest4

--  Erstelle eine Procedure, der man als Parameter eine OrderID übergeben kann.
--	Bei Ausführung soll der Rechnungsbetrag dieser Order ausgegeben werden 
--  SUM(Quantity * UnitPrice + Freight) = RechnungsSumme.
CREATE PROCEDURE sp_RechnungsSummeTest @OrderID INT
AS
SELECT Orders.OrderID, SUM(Quantity * UnitPrice + Freight) as RechnungsSumme
FROM Orders JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
WHERE Orders.OrderID = @OrderID
GROUP BY Orders.OrderID

EXEC sp_RechnungsSummeTest 10252


SELECT * FROM Orders
JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID