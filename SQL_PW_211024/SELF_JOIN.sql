SELECT * FROM Employees

-- Vorgesetzter ID,LastName Vorgesetzen, MitarbeiterID, LastName Mitarbeiter
SELECT E1.EmployeeID, E1.LastName as Vorgesetzer, E2.EmployeeID, E2.LastName as Mitarbeiter 
FROM Employees as E1
JOIN Employees as E2 ON E1.EmployeeID = E2.ReportsTo

-- CROSS JOIN (A x B) (830 x 99)
SELECT * FROM Orders CROSS JOIN Customers

SELECT * FROM Orders
SELECT * FROM Customers

