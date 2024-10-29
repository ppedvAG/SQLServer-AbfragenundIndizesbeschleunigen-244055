/*
	Partitionierung:
	Aufteilung in "mehrere" Tabellen
	Einzelne Tabellen bleibt bestehen, aber intern werden die DATEN partitioniert
*/

-- Anfordungen:
-- Partitionsfunktion: Stellt die Bereiche dar (0-100, 101-200, 201-Ende)
-- Partitionsschema: Weist die einzelnen Partitionen auf Dateigruppen zu

-- 0-100-200-Ende
CREATE PARTITION FUNCTION pf_Zahl(int) AS
RANGE LEFT FOR VALUES (100,200)

-- Partitionsschema: Für ein Partitionsschema muss immer eine extra Dateigruppe existieren
CREATE PARTITION SCHEME sch_ID as 
PARTITION pf_Zahl TO (P1,P2,P3)

-- dateien hinzufügen zur Dateigruppe

-- Dateigruppe erstellen
ALTER DATABASE SchlechteDemo ADD FILEGROUP P1

-- Dateien erstellen
ALTER DATABASE SchlechteDemo
ADD FILE
(
	NAME = N'P1Datei',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\P1Datei.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
)
TO FILEGROUP P1

-- Partitionsschema auf eine Tabelle legen
CREATE TABLE M003_Test
(
	id int identity,
	zahl float
) ON sch_ID(id)

-- Befüllen
BEGIN TRAN
DECLARE @i INT = 0;
WHILE @i < 1000
BEGIN
	INSERT INTO M003_Test VALUES (RAND() * 1000)
	SET @i += 1
END 
Commit

-- Nichts besondere zu sehen
SELECT * FROM M003_Test

-- Hier wird die unterste Partition durchsuchen (100DS)
SELECT * FROM M003_Test
WHERE ID < 50

-- Übersicht über Partition verschaffen
SELECT OBJECT_NAME(OBJECT_ID), * FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')

SELECT $partition.pf_Zahl(50)
SELECT $partition.pf_Zahl(150)
SELECT $partition.pf_Zahl(250)

-- 0-500, 501-1000, 1001-Ende

CREATE PARTITION FUNCTION Uebung(int) AS
RANGE LEFT FOR VALUES (500, 1000)

CREATE PARTITION SCHEME sch_Uebung as
PARTITION Uebung TO (Test1, Test2, Test3)

ALTER DATABASE SchlechteDemo ADD FILEGROUP Test1
ALTER DATABASE SchlechteDemo ADD FILEGROUP Test2
ALTER DATABASE SchlechteDemo ADD FILEGROUP Test3

ALTER DATABASE SchlechteDemo
ADD FILE
(
	NAME = N'Test1Datei',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\Test1Datei.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
)
TO FILEGROUP Test1

ALTER DATABASE SchlechteDemo
ADD FILE
(
	NAME = N'Test2Datei',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\Test2Datei.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
)
TO FILEGROUP Test2

ALTER DATABASE SchlechteDemo
ADD FILE
(
	NAME = N'Test3Datei',
	FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLKURS\MSSQL\DATA\Test3Datei.ndf',
	SIZE = 8192KB,
	FILEGROWTH = 65536KB
)
TO FILEGROUP Test3

CREATE TABLE Uebung
(
	id int identity,
	zahl float
) on sch_Uebung(id)

-- Befüllen
BEGIN TRAN
DECLARE @i INT = 0;
WHILE @i < 1000
BEGIN
	INSERT INTO Uebung VALUES (RAND() * 1000)
	SET @i += 1
END 
Commit


SELECT OBJECT_NAME(OBJECT_ID), * FROM sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED')


-- Pro Datensatz die Partition + Filegroup anhängen
SELECT * FROM M003_Test t
JOIN
(
	SELECT name, ips.partition_number
	FROM sys.filegroups fg --Name

	JOIN sys.allocation_units au
	ON fg.data_space_id = au.data_space_id

	JOIN sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED') ips
	ON ips.hobt_id = au.container_id

	WHERE OBJECT_NAME(ips.object_id) = 'M003_Test'
) x
ON $partition.pf_Zahl(t.id) = x.partition_number
