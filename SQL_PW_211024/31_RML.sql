/*
	Replay Markup Language (RML) sammeln von Tools & Dienste, um unsere SQL Server Workloads zu analysieren und "nachzuspielen"
	=> Ermöglicht es Administratoren, SQL Abfragen zu erfassen, erneut auszuführen und zu untersuchen
		=> Probleme bzgl. Abfrageleistung, Ressourcenverbrauch zu identifizieren und beheben

	Funktion und Hauptmerkmale des RML-Dienst:

	1. Workload-Replay: Workloads erneut abzuspielen (z.B Profiler Trace)

	2. Leistungsanalyse und Vergleich: Vor- und Nachänderungen (z.B Indexänderungen oder Abfrageoptimierungen) abspielen
		und die Leistung verglechen

	3.  Ermittlung problematische Abfragen: Zeit und Ressourcen der Abfrage

	4. Benutzer- und Sitzungsüberwachung:
	- Kann Abfragen einzelnen Benutzern und Sitzungen zuordnen
	=> Hilfreich um zu analysieren, wie bestimmte Benutzer oder 
	   Anwendungen die SQL Server-Instanz belasten

	5. Parallelisierung und Lasttests:
	- Unterstützt das parallele Abspielen von Workloads, was sich für Lasttests eignen


	Anwendungsfälle des RML-Dienstes:
	- Verbesserung der Abfragen
	- Troubleshooting & Performance Tuning
	- Kapazitätsplanung und Skalierbarkeit

*/