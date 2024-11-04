-- MAXDOP
-- Maximum Degree of Parallelism
-- Steuerung der Anzahl Prozessorkerne pro Abfrage
-- Parallelisierung passiert von allein

-- MAXDOP kann auf 3 ebenen gesetzt werden
-- 1. Abfrage
-- 2. Server
-- 3. Datenbank

SET STATISTICS TIME, IO on

SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
-- Diese Abfrage wird parallelisiert durch die zwei Schwarze Pfeile in dem gelben Kreis
-- CPU-Zeit: 622ms, verstrichene Zeit: 1130ms

SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 1)
-- CPU-Zeit: 375ms, verstrichene Zeit: 1180ms


SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 2)
-- CPU-Zeit: 610ms, verstrichene Zeit: 1336ms

SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 4)
-- CPU-Zeit: 796ms, verstrichene Zeit: 1169ms


SELECT Freight, FirstName, LastName
FROM M005_Index
WHERE Freight > (SELECT AVG(Freight) FROM M005_Index)
OPTION(MAXDOP 8)
-- CPU-Zeit: 514ms, verstrichene Zeit: 1029ms