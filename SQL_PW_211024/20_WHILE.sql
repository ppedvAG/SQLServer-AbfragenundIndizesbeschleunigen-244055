-- WHILE - leitet eine Schleifenanweisung ein

DECLARE @Counter INT = 0

WHILE @Counter <= 5
BEGIN
SELECT 'Hallo'
SET @Counter = @Counter + 1
END

-- Aufpassen vor Endlosschleife
WHILE 1=1
BEGIN
SELECT 'Hallo'
END


-- Zusätzliche IF Prüfung innerhalb der WHILE Schleife:
DECLARE @CounterTwo INT = 0

WHILE @CounterTwo <= 5
BEGIN

IF @CounterTwo = 2 BEGIN SELECT 'Bin bei 2' END
ELSE BEGIN SELECT @CounterTwo END

SET @CounterTwo = @CounterTwo + 1

END
SELECT 'Ende'