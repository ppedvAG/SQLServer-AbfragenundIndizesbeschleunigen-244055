/*
	Dynamischen Verwaltungssichten geben Serverstatusinformationen zur�ck,
	die verwendet werden k�nnen, um
	den Status einer Serverinstanz zu �berwachen, Probleme diagnostizieren => Leistung zu optimieren
*/

SELECT wait_type, wait_time_ms
FROM sys.dm_os_wait_stats