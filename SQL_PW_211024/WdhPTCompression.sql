/*
	Code für Tabelle: (Vorgegeben)
*/

CREATE TABLE Wiederholung
(
	datum date,
	umsatz float
) on [SchemaName](umsatz)

BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 100000
BEGIN
		INSERT INTO Wiederholung VALUES
		(DATEADD(DAY, FLOOR(RAND()*1095), '20210101'), RAND() * 1000)
		SET @i += 1
END
COMMIT


-- Pro Datensatz die Partition + Filegroup anhängen
SELECT * FROM Wiederholung t
JOIN
(
	SELECT name, ips.partition_number
	FROM sys.filegroups fg --Name

	JOIN sys.allocation_units au
	ON fg.data_space_id = au.data_space_id

	JOIN sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED') ips
	ON ips.hobt_id = au.container_id

	WHERE OBJECT_NAME(ips.object_id) = 'Wiederholung'
) x
ON $partition.Umsatz(t.id) = x.partition_number

/* 
	Nutze nun mithilfe von der Salamitaktik bei Dateigruppen und Partitionierung um
	die Umsätze zu unterteilen
	Bereiche: 0-300, 300-600, 600-1000

	Zum Schluss komprimiere mir die Tabelle in der
	Row Ansicht:
	Page Ansicht:
	Und zeige an wieviel CPU-Leistung jeweils jede Ansicht braucht + Lesevorgaenge
*/
