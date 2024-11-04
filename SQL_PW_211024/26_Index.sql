/*
	Index:

	Table Scan: Durchsucht unsere Tabelle von Oben nach Unten durch (langsam)
	Index Scan: Durchsuche bestimmte der Teile der Tabelle (besser)
	Index Seek: Gehe in einen Index gezielt zu den Daten hin (am besten)

	Clustered Index / Gruppierten Index:
	- Normaler Index, welcher sich immer selber Sortiert
	- bei INSERT/DELETE werden die Daten herumgeschoben und neu sortiert
	- Kann nur pro Tabelle einmal existieren
	- Wird standardm‰ﬂig auf den Prim‰rschl¸ssel gelegt
	-> Kostet Performance

	Wann brauch ich den Gruppierten Index:
	- Sehr gut bei Abfragen nach Bereichen und rel. Groﬂen Ergebnismengen: <, >, between, like

	Non-Clustered Index / Nicht-gruppierter Index:
	- Standardindex
	- Zwei Komponenten: Schl¸sselspalte, inkludierten Spalten
	- inkludierten Spalten wird entschieden wann der Index verwendet wird

	Wann brauch ich den denn Nicht-gruppierten Index:
	- Sehr gut bei Abfragen auf rel. eindeutige Werte bzw geringen Ergebnismengen
	- Kann mehrfach verwendet werden (999-mal)

*/

SELECT  * INTO M005_Index
FROM M004_Kompression

SET STATISTICS TIME, IO ON

-- Tabellenscan
SELECT * FROM M005_Index

SELECT * FROM M005_Index
WHERE OrderID >= 11000
-- Table Scan
-- Cost: 21, logische Lesevorg‰nge: 28266, CPU-Zeit: 515ms, verstrichene Zeit = 1032ms

-- Neuer Index: NCIX_OrderID
SELECT * FROM M005_Index
WHERE OrderID >= 11000
-- Index Seek
-- Cost: 2,17, logische Lesevorg‰nge: 2887, CPU-Zeit: 172ms, verstrichene Zeit = 961ms

-- Indizes anschauen
SELECT OBJECT_NAME(OBJECT_ID), index_level, page_count
FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')
WHERE OBJECT_NAME(object_id) = 'M005_Index'

SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE ProductName = 'Chocolade'
-- Table Scan
-- Cost: 21, logische Lesevorg‰nge: 28266, CPU-Zeit: 185ms, verstrichene Zeit = 99ms

-- Neuer Index: NCIX_ProductName
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE ProductName = 'Chocolade'
-- Index Seek
-- Cost: 0,02, logische Lesevorg‰nge: 26, CPU-Zeit: 0ms, verstriche Zeit = 68ms

-- Hier wird auch der NCIX_ProductName durchgegangen
-- Hier fehlt die ContactName Spalte
SELECT CompanyName, ProductName, Quantity * UnitPrice
FROM M005_Index
WHERE ProductName = 'Chocolade'

-- Hier wird NCIX_ProductName teils durchgegangen
-- Alle Inkludierten Spalten werden geholt + ein Lookup auf die fehlenden Daten die im Index nicht erhalten sind gemacht
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice, Freight
FROM M005_Index
WHERE ProductName = 'Chocolade'
-- Cost: 4,9, logische Lesevorg‰nge: 1562, CPU-Zeit: 16ms, verstrichene Zeit = 123ms

-- Neuer Index: NCIX_Freight
SELECT CompanyName, ContactName, ProductName, Quantity * UnitPrice, Freight, FirstName, LastName
FROM M005_Index
WHERE ProductName = 'Chocolade'
-- Cost: 0,02: logische Lesevorg‰nge: 33, CPU-Zeit = 16ms, verstrichene Zeit = 114ms

SELECT * FROM M005_Index

ALTER TABLE M005_Index ADD id INT identity


-- WITH SCHEMABINDING: Solange diese View exisitert, kann die Tabellenstruktur nicht ver‰ndert werden
CREATE VIEW Adressen WITH SCHEMABINDING
AS 
SELECT id, CompanyName, Address, City, Region, PostalCode, Country
FROM dbo.M005_Index
GO

-- Clustered Index Scan
SELECT * FROM Adressen
ORDER BY 1 DESC

SELECT id, CompanyName, Address, City, Region, PostalCode, Country
FROM dbo.M005_Index

-- Clustered Index Insert
INSERT INTO M005_Index (CompanyName, Address, City, Region, PostalCode, Country)
VALUES ('PPEDV', 'Eine Straﬂe', 'Irgendwo', NULL, NULL, NULL)


