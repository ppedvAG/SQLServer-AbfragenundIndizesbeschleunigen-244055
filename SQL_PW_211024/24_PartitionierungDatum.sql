USE SchlechteDemo

-- Partitionsschema & Partitionsfunktion verwerfen
-- DROP PARTITION SCHEME [SchemaName]
-- DROP PARTITION FUNCTION [FunktionsNamen]

CREATE PARTITION FUNCTION pf_Datum(date) AS
RANGE LEFT FOR VALUES('20211231', '20221231', '20231231')

CREATE PARTITION SCHEME sch_Datum AS
PARTITION pf_Datum TO (PD1, PD2, PD3, PD4)

CREATE TABLE M003_Umsatz
(
	datum date,
	umsatz float
) on sch_Datum(datum)


INSERT INTO M003_Umsatz
SELECT * FROM M002_Umsatz

SELECT * FROM M003_Umsatz t
JOIN
(
	SELECT name, ips.partition_number
	FROM sys.filegroups fg --Name

	JOIN sys.allocation_units au
	ON fg.data_space_id = au.data_space_id

	JOIN sys.dm_db_index_physical_stats(DB_ID(), 0, -1, 0, 'DETAILED') ips
	ON ips.hobt_id = au.container_id

	WHERE OBJECT_NAME(ips.object_id) = 'M003_Umsatz'
) x
ON $partition.pf_Datum(t.datum) = x.partition_number

INSERT INTO M003_Umsatz
VALUES('20240101', 105.292330106276)
