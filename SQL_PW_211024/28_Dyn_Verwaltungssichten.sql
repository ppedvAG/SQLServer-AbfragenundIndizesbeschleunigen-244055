/*
	Dynamischen Verwaltungssichten geben Serverstatusinformationen zurück,
	die verwendet werden können, um
	den Status einer Serverinstanz zu überwachen, Probleme diagnostizieren => Leistung zu optimieren
*/

SELECT wait_type, wait_time_ms
FROM sys.dm_os_wait_stats