/*
	Dateigruppen:
	Datenbank auf mehrere Dateien aufteilen, und verschiedenen Datentr‰ger in weiterer Folge
	[PRIMARY]: Hauptgruppe, existiert immer, enth‰lt standardm‰ﬂig alle Dateien

	Das Hauptfile hat die Endung .mdf
	Weitere Files haben die Endung .ndf
	Log Files haben die Endung .ldf
*/

/*
	Rechtsklick auf die Datenbank -> Eigenschaften
	Dateigruppe:
		- Hinzuf¸gen, Namen vergeben
	Dateien:
		- Hinzuf¸gen, Namen vergeben, Pfad angeben
*/

CREATE TABLE M002_FG2
(
	id int identity,
	test char(4100)
)

INSERT INTO M002_FG2
VALUES('XYZ')
GO 20000



-- Wie verschiebe ich diese Tabelle auf eine andere Dateigruppe?
-- Neu erstellen, DAten verschieben, Alte Tabelle lˆschen
CREATE TABLE M002_FG2_2
(
	id int identity,
	test char(4100)
) on [Aktiv]

INSERT INTO M002_FG2_2
SELECT * FROM M002_FG2
-- Identity hinzuf¸gen per Designer
-- Extras -> Optionen -> Designer -> Tabellen neu erstellen -> ausschalten



-- Salamitaktik
-- Groﬂe Tabellen in kleinere Tabellen aufteilen

CREATE TABLE M002_Umsatz
(
	datum date,
	umsatz float
)

BEGIN TRAN
DECLARE @i int = 0
WHILE @i < 100000
BEGIN
	INSERT INTO M002_Umsatz VALUES
	(DATEADD(DAY, FLOOR(RAND()*1095), '20210101'), RAND()*1000)
	SET @i += 1
END
COMMIT

SELECT * FROM M002_Umsatz ORDER BY datum

/*
	Pl‰ne:
	Zeigt den genauen Ablauf einer Abfrage + Details an
*/

CREATE TABLE M002_Umsat2021
(
	datum date,
	umsatz float
)

INSERT INTO M002_Umsat2021
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2021

-----------------------------------------
CREATE TABLE M002_Umsat2022
(
	datum date,
	umsatz float
)

INSERT INTO M002_Umsat2022
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2022

---------------------------------------
CREATE TABLE M002_Umsat2023
(
	datum date,
	umsatz float
)

INSERT INTO M002_Umsat2021
SELECT * FROM M002_Umsatz WHERE YEAR(datum) = 2023

CREATE VIEW UmsatzGesamt
AS
SELECT * FROM M002_Umsat2021
UNION ALL
SELECT * FROM M002_Umsat2022
UNION ALL 
SELECT * FROM M002_Umsat2023

SELECT * FROM UmsatzGesamt