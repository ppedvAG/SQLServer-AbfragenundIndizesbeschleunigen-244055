USE Northwind
GO

-- Stored Procedure / gespeicherte Prozedure

/*
	- Sind gespeicherte SQL Anweisungen (nicht nur SELECT, sondern auch alles andere)
	- Arbeiten mit Variablen
	- Praktisch zum "automatisieren" von Code
	- Prozeduren verwenden ihren QueryPlan jedes mal wieder
*/

CREATE PROCEDURE spRechnungsByOrderIDTest @OrderID INT
AS
SELECT * FROM Orders
WHERE OrderID = @OrderID
GO

EXEC spRechnungsByOrderIDTest 10251
GO

-- Default Werte
CREATE PROCEDURE spKundenNachLandCityTest @Country varchar(50) = 'Germany',
@City varchar(50) = 'Berlin'
AS
SELECT * FROM Customers WHERE Country = @Country AND City = @City
GO

EXEC spKundenNachLandCityTest 
GO

/*
	Erstellt eine Prozedur, wo wir einen neuen Kunden in Customers eintragen
	CustomerID char(5), CompanyName varchar(40)
	Country varchar(30), City varchar(30)
*/
CREATE PROCEDURE spNeuenKunden
@CustomerID char(5), @CompanyName varchar(40),
@Country varchar(30), @City varchar(30)
AS
INSERT INTO Customers (CustomerID, CompanyName, Country, City)
VALUES (@CustomerID, @CompanyName, @Country, @City)
GO

EXEC spNeuenKunden 'ALDIA', 'ppedv AG', 'Germany', 'Burghausen'
EXEC spNeuenKunden ABDEF, TestFirma, Germany, Burghausen

SELECT * FROM Customers