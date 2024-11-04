USE Northwind

/*
	CASE - unterscheiden wir definierte Fälle, die die Ausgabe ändern
*/

-- Wenn ein Fall gefunden wird, dann passiert xyz, wenn nicht das ist das Ergebnis NULL
SELECT UnitsInStock,
CASE
	WHEN UnitsInStock < 15 THEN 'Nachbestellen!'
	WHEN UnitsInStock > 15 THEN 'Die Menge passt!'
END as Prüfung
FROM Products

-- Alternative mit ELSE einen "Notausgang" definieren!:
SELECT UnitsInStock,
CASE
	WHEN UnitsInStock < 15 THEN 'Nachbestellen!'
	WHEN UnitsInStock > 15 THEN 'Die Menge passt!'
	ELSE 'Fehler!'
END as Prüfung
FROM Products

-- Funktioniert mit UPDATE:
UPDATE Customers
SET City =
CASE
	WHEN Country = 'Germany' THEN 'München'
	WHEN Country = 'France' THEN 'Lloret'
	ELSE City
END 

SELECT City, Country from Customers

-- Auch im GROUP BY
SELECT SUM(UnitsInStock),
CASE
	WHEN UnitsInStock <= 15 THEN 'Nachbestellen!'
	WHEN UnitsInStock > 15 THEN 'Die Menge passt!'
END AS Prüfung
FROM Products
GROUP BY 
CASE
	WHEN UnitsInStock <= 15 THEN 'Nachbestellen!'
	WHEN UnitsInStock > 15 THEN 'Die Menge passt!'
END