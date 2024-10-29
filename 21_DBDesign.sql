/*
	Seite:
	8192B (8kB) Größe 
	8060B für tatsächliche Daten
	132B sind Management Daten

	Seiten 1:1
	Ziel: Leerer Raum minimieren, darf existieren, aber sollte minimiert werden

*/

-- dbcc: Database Console Commands
-- showcontig: Zeigt Seiteninformationen über ein Datenbankobjekt
dbcc showcontig('Orders')

CREATE DATABASE SchlechteDemo

USE SchlechteDemo

-- Absichtlich ineffiziente Tabelle
CREATE TABLE M001_Test1
(
	id int identity,
	test char(4100)
)

INSERT INTO M001_Test1
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test1')

-------------------------------
CREATE TABLE M001_Test2
(
	id int identity,
	test varchar(4100)
)

INSERT INTO M001_Test2
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test2')
-------------------------------------------
CREATE TABLE M001_Test3
(
	id int identity,
	test varchar(max)
)

INSERT INTO M001_Test3
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test3') -- Seiten: 52
----------------------------------------
CREATE TABLE M001_Test4
(
	id int identity,
	test nvarchar(max)
)

INSERT INTO M001_Test4
VALUES('XYZ')
GO 20000

dbcc showcontig('M001_Test4') -- Seiten: 60

-- Statistiken für Zeit und Lesevorgänge zu aktivieren/deaktivieren
SET STATISTICS time, io on
SELECT * FROM M001_Test4

-- logische LOB-Lesevorgänge für sehr große Datensätze

-- Northwind optimieren
-- Customers Tabelle
dbcc showcontig('Customers')
-- 70% Füllgrad -> mittelmäßig
-- 80% Füllgrad -> gut
-- 90% Füllgrad -> Sehr gut

USE SchlechteDemo

CREATE TABLE M001_TestFloat
(
	id INT identity,
	zahl float -- 8B
)

INSERT INTO M001_TestFloat
VALUES (2.2)
GO 20000

dbcc showcontig('M001_TestFloat')

-- Beispiel decimal(2, 1)

CREATE TABLE M001_TestDecimal
(
	id INT identity,
	zahl decimal(2,1)
)

INSERT INTO M001_TestDecimal
VALUES(2.2)
GO 20000

dbcc showcontig('M001_TestDecimal') -- Seiten: 47; Seitendichte: 94%

-- Schnellere Variante
BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 20000
BEGIN
	INSERT INTO M001_TestDecimal VALUES(2.2)
	SET @i += 1
END 
COMMIT;

SET STATISTICS time, IO off

CREATE TABLE CharTest 
(
	id int identity,
	test char(2000)
)

INSERT INTO CharTest
VALUES('XYZ')
GO 20000

dbcc showcontig('CharTest')