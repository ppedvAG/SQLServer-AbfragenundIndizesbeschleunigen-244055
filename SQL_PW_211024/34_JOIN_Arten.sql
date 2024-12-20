-- JOIN

/*
	SQL Server versucht aus einer Reihe von Ausführungsplänen, die er vorab ermittelt den günstigstens herauszufinden

	- Meist "Auffälligkeiten" entdecken
	- unter anderem Sortieroperatoren aufteauchen, obwohl wir z.B garkein Order By haben da liegt an den JOIN Methoden

	inner HASH join
	=> ermittelt eine Hashtabelle der übereinstimmenden JOIN spalten der tabelle
	- Gilt bei Großen tabellen, leicht parallelisierbar, kein Index vorhanden

	inner merge join
	=> beide tabellen werden jeweils gleichzeitig durchsucht
	- funktioniert nur wenn sortiert wird
	(entweder durch CL IX oder ORDER BY)

	inner loop join
	kleine Tabellen wird zeilenweise durchlaufen 
	große Tabellen wird nach einem Wert gesucht

*/

SET STATISTICS time, IO ON

SELECT * FROM Customers 
INNER HASH JOIN Orders on customers.CustomerID = orders.CustomerID
-- Cost: 0,04%, Logische Lesevorgänge: 28, CPU-Zeit: 0ms, verstrichenen Zeit = 0ms

SELECT * FROM Customers
INNER MERGE JOIN Orders on customers.CustomerID = orders.CustomerID
-- Cost 0,007%, Logische Lesevorgänge: 28, CPU-Zeit: 0ms, verstrichenen Zeit = 0ms

SELECT * FROM Customers
INNER LOOP JOIN Orders ON Customers.CustomerID = orders.CustomerID
-- Cost 0,003%, Logische Lesevorgänge: 1957, CPU-Zeit: 0ms, verstrichenen Zeit = 0ms