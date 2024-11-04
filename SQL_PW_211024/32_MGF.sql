/*
	Memory Grant Feedback => dynamische optimierung von Speicherzuteilung der Abfragen

	Funktionsweise:

	1. Speichereinteilung:
		- Beim ersten mal ausf�hren => gewisse menge an speicher zuweisen
		- Orientierung => gesch�tzte Zeilen  
	
	2. Beobachtung der tats�chlichen nutzung:
		- Beim ausf�hren der Abfrage, �berpr�ft er den hergenommenen Speicher und �berpr�ft den mit der zugewiesenene Menge

	3. Feedback-Schleife:
		- SQL Server stellt fest: zugewiesen Speicher ist zu wenig => erh�ht Ihn
		- Wenn Speicher zu viel: wird der Speicher gek�rzt

	=> Verbessert Performance, Reduzierte Ressourcenauslastung, bessere Abfrageparallelit�t

	Voraussetzung:
	- Verf�gbar ab SQL Server 2017 und h�her:
	- Gilt f�r wiederholte Abfragen aufgrund genauigkeit
*/