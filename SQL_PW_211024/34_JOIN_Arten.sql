-- JOIN

/*
	SQL Server versucht aus einer Reihe von Ausf¸hrungspl‰nen, die er vorab ermittelt den g¸nstigstens herauszufinden

	- Meist "Auff‰lligkeiten" entdecken
	- unter anderem Sortieroperatoren aufteauchen, obwohl wir z.B garkein Order By haben da liegt an den JOIN Methoden

	inner HASH join
	=> ermittelt eine Hashtabelle der ¸bereinstimmenden JOIN spalten der tabelle
	- Gilt bei Groﬂen tabellen, leicht parallelisierbar, kein Index vorhanden

	inner merge join
	=> beide tabellen werden jeweils gleichzeitig durchsucht
	- funktioniert nur wenn sortiert wird
	(entweder durch CL IX oder ORDER BY)

	inner loop join
	kleine Tabellen wird zeilenweise durchlaufen 
	groﬂe Tabellen wird nach einem Wert gesucht

*/

SET STATISTICS time, IO ON

SELECT * FROM Customers 
INNER HASH JOIN Orders on customers.CustomerID = orders.CustomerID
-- Cost: 0,04%, Logische Lesevorg‰nge: 28, CPU-Zeit: 0ms, verstrichenen Zeit = 0ms

SELECT * FROM Customers
INNER MERGE JOIN Orders on customers.CustomerID = orders.CustomerID
-- Cost 0,007%, Logische Lesevorg‰nge: 28, CPU-Zeit: 0ms, verstrichenen Zeit = 0ms

SELECT * FROM Customers
INNER LOOP JOIN Orders ON Customers.CustomerID = orders.CustomerID
-- Cost 0,003%, Logische Lesevorg‰nge: 1957, CPU-Zeit: 0ms, verstrichenen Zeit = 0ms