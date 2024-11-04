-- Seitendichte überprüfung
-- Database Console Commands
-- Zeigt Seiteninformationen über ein Datenbankobjekt
dbcc showcontig('Orders')

/*
	-- Seiten: 20
	-- Blöcke: 3
	-- Seitendichte: 98,19%
	-- Bewerten: Desto höher unsere Seitendichte, desto besser!
*/

-- Dateigruppen:
-- Standard: [PRIMARY] Hauptgruppe

-- Anforderungen für eine Partitionierung
-- Partitionsfunktion: Stellt die Bereiche dar
-- Paritionsschema: Weist die einzelnen Partitionen auf Dateigruppen zu

-- Partitionsfunktion:
CREATE PARTITION FUNCTION [Name](Datentypen) AS
RANGE LEFT FOR VALUES (Wert1, Wert2)

-- Partitionsschema:
CREATE PARTITION SCHEME [Schemaname] AS
PARTITION [Partitionsname] TO (Dateigruppe1, Dateigruppe2, ... usw)

-- Schema auf die Tabelle legen
CREATE TABLE Test
(
	id int identity,
	zahl float
) ON [SchemaName](id)

SET STATISTICS time, io ON

-- Index

/*
	Table Scan: langsam
	Index Scan: (besser)
	Index Seek: am besten

	- Gruppierter Index   => relativ Große Datenmengen verarbeiten kann
	-						relative Angaben: between, like, <, >
	- Nicht-gruppierter Index => kleinere Datenmengen 
	-						fixen Angaben




*/
