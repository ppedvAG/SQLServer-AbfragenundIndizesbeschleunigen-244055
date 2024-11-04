/*
	Memory Grant Feedback => dynamische optimierung von Speicherzuteilung der Abfragen

	Funktionsweise:

	1. Speichereinteilung:
		- Beim ersten mal ausführen => gewisse menge an speicher zuweisen
		- Orientierung => geschätzte Zeilen  
	
	2. Beobachtung der tatsächlichen nutzung:
		- Beim ausführen der Abfrage, überprüft er den hergenommenen Speicher und überprüft den mit der zugewiesenene Menge

	3. Feedback-Schleife:
		- SQL Server stellt fest: zugewiesen Speicher ist zu wenig => erhöht Ihn
		- Wenn Speicher zu viel: wird der Speicher gekürzt

	=> Verbessert Performance, Reduzierte Ressourcenauslastung, bessere Abfrageparallelität

	Voraussetzung:
	- Verfügbar ab SQL Server 2017 und höher:
	- Gilt für wiederholte Abfragen aufgrund genauigkeit
*/