CREATE TABLE mytemp (
		rid BIGINT /*IDENTITY (1, 1)*/ NOT NULL,
		at1 INT NULL,
		at2 INT NULL,
		at3 INT NULL,
		lixo varchar(100) NULL
);

TRUNCATE TABLE myTemp;
-- Record the Start Time
SET IDENTITY_INSERT mytemp ON
DECLARE @start_time DATETIME, @end_time DATETIME;
SET @start_time = GETDATE();
PRINT @start_time
-- Generate random records
DECLARE @val as int = 1;	
DECLARE @nelem as int = 50000;
SET nocount ON
WHILE @val <= @nelem
BEGIN
 DBCC DROPCLEANBUFFERS; -- need to be sysadmin
 INSERT mytemp (rid, at1, at2, at3, lixo)
 SELECT cast((RAND()*@nelem*40000) as int), cast((RAND()*@nelem) as int),
 cast((RAND()*@nelem) as int), cast((RAND()*@nelem) as int),
 'lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo...lixo';
 SET @val = @val + 1;
 END
 PRINT 'Inserted ' + str(@nelem) + ' total records'
 -- Duration of Insertion Process
 SET @end_time = GETDATE();
PRINT 'Milliseconds used: ' + CONVERT(VARCHAR(20), DATEDIFF(MILLISECOND,
@start_time, @end_time));
/*Inserted      50000 total records
Milliseconds used: 43603
Fragmentation - Page fullness 68,96%
Total Fragmentation 97,67
*/

--c1
CREATE UNIQUE CLUSTERED INDEX ridIndex_c1 ON mytemp(rid)  WITH (FILLFACTOR = 65, PAD_INDEX = ON)
/*
Inserted      50000 total records
Milliseconds used: 39043
Fragmentation - Page fullness 68,89%
Total Fragmentation 99,16%*/
--c2

DROP INDEX ridIndex_c1 ON mytemp
CREATE UNIQUE CLUSTERED INDEX ridIndex_c2 ON mytemp(rid)  WITH (FILLFACTOR = 80, PAD_INDEX = ON)
/*Inserted      50000 total records
Milliseconds used: 39506
Fragmentation - Page fullness 68.37 %
Total Fragmentation 98,72%*/
--c3
CREATE UNIQUE CLUSTERED INDEX  ridIndex_c3 ON mytemp(rid) WITH (FILLFACTOR = 90, PAD_INDEX = ON)
/*Inserted      50000 total records
Milliseconds used: 39843
Fragmentation - Page fullness 67,51%
Total Fragmentation 98,85%
*/


--d)
CREATE TABLE mytemp (
		rid BIGINT IDENTITY(1,1) NOT NULL,
		at1 INT NULL,
		at2 INT NULL,
		at3 INT NULL,
		lixo varchar(100) NULL
);

--d)1
/*Inserted      50000 total records
Milliseconds used: 40170
Fragmentation - Page fullness 68,21%
Total Fragmentation 98,93%
*/
--d)2
/*Inserted      50000 total records
Milliseconds used: 40603
Fragmentation - Page fullness 68,53%
Total Fragmentation 90,05%
Completion time: 2022-05-29T20:13:48.8389309+01:00*/

--d)3
/* Inserted      50000 total records
Milliseconds used: 40776
Fragmentation - Page fullness 68,45%
Total Fragmentation 90,05%*/

--e
CREATE INDEX Idx1 ON mytemp(at1);
CREATE INDEX Idx2 ON mytemp(at2);
CREATE INDEX Idx3 ON mytemp(at3);
CREATE INDEX Idx4 ON mytemp(lixo)

--com idex 
/*Inserted      50000 total records
Milliseconds used: 50690

--sem idex
/*Inserted      50000 total records
Milliseconds used: 37333

--Podemos que concluir que a inser��o dos indices � mais lenta.
