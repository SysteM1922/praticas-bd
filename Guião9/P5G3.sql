--- Creation Script)
create table Department(
	Dnumber			int				not null,
	Dname			varchar(20)		not null,
	Mgr_Ssn			char(12)		null,		
	Mgr_start_date	date			null,

	primary key (Dnumber)
);

create table Employee (
	Fname		varchar(15)		not null,
	Minit		char(1)					,
	Lname		varchar(15)		not null,
	Ssn			char(12)			not null,
	Bdate		date,
	emp_address	varchar(30),			
	Sex			char(1)			not null,
	Salary		decimal(6,2)	not null	CHECK(Salary >= 0),
	Super_ssn	char(12),
	Dno			int				not null
	
	primary key (Ssn),			
	foreign key (Dno) references Department (Dnumber)
);

create table Dept_locations(
	Dnumber		int			not null,
	Dlocation	varchar(20)	not null

	primary key (Dnumber, Dlocation),
	foreign key (Dnumber) references Department(Dnumber)
);

create table Project(
	Pname		varchar(30)		not null,
	Pnumber		int				not null		CHECK(Pnumber> 0),
	Plocation	varchar(15)		not null,
	Dnum		int				not null,

	primary key (Pnumber),
	foreign key (Dnum) references Department (Dnumber)
);

create table Works_on(
	Essn	char(12)		not null,
	Pno		int				not null,
	wo_Hours	decimal(3,1)	not null,

	primary key (Essn, Pno),
	foreign key (Pno) references Project (Pnumber),
	foreign key (Essn) references Employee (Ssn)
);


create table DDependent(
	Essn			char(12)		not null,
	Dependent_name	varchar(30)	not null,
	Sex				char(1)		not null,
	Bdate			date				,
	Relationship	varchar(15)	not null

	primary key (Essn, Dependent_name),
	foreign key (Essn) references Employee (Ssn)
);

alter table Employee add constraint employeeSuper foreign key (Super_ssn) references Employee (Ssn);

INSERT INTO	Department VALUES('Investigacao',1,21312332,'2010-08-02')
INSERT INTO	Department VALUES('Comercial',2,321233765,'2013-05-16')
INSERT INTO	Department VALUES('Logistica',3,41124234,'2013-05-16')
INSERT INTO	Department VALUES('Recursos Humanos',4,12652121,'2014-04-02')
INSERT INTO	Department VALUES('Desporto',5,NULL,NULL)

INSERT INTO Employee VALUES('Paula','A','Sousa',183623612,'2001-08-11','Rua da FRENTE','F',1450.00,NULL,3)
INSERT INTO Employee VALUES('Carlos','D','Gomes',21312332,'2000-01-01','Rua XPTO','M',1200.00,NULL,1)
INSERT INTO Employee VALUES('Juliana','A','Amaral',321233765,'1980-08-11','Rua BZZZZ','F',1350.00,NULL,3)
INSERT INTO Employee VALUES('Maria','I','Pereira',342343434,'2001-05-01','Rua JANOTA','F',1250.00,21312332,2)
INSERT INTO Employee VALUES('Joao','G','Costa',41124234,'2001-01-01','Rua YGZ','M',1300.00,21312332,2)
INSERT INTO Employee VALUES('Ana','L','Silva',12652121,'1990-03-03','Rua ZIG ZAG','F',1400.00,21312332,2)

INSERT INTO DDependent VALUES(21312332,'Joana Costa','F','2008-04-01','Filho')
INSERT INTO DDependent VALUES(21312332,'Maria Costa','F','1990-10-05','Neto')
INSERT INTO DDependent VALUES(21312332,'Rui Costa','M','2000-08-04','Neto')
INSERT INTO DDependent VALUES(321233765,'Filho Lindo','M','2001-02-22','Filho')
INSERT INTO DDependent VALUES(342343434,'Rosa Lima','F','2006-03-11','Filho')
INSERT INTO DDependent VALUES(41124234,'Ana Sousa','F','2007-04-13','Neto')
INSERT INTO DDependent VALUES(41124234,'Gaspar Pinto','M','2006-02-08','Sobrinho')

INSERT INTO Project VALUES('Aveiro Digital',1,'Aveiro',3)
INSERT INTO Project VALUES('BD Open Day',2,'Espinho',2)
INSERT INTO Project VALUES('Dicoogle',3,'Aveiro',3)
INSERT INTO Project VALUES('GOPACS',4,'Aveiro',3)

INSERT INTO Works_on VALUES(183623612,1,20.0)
INSERT INTO Works_on VALUES(183623612,3,10.0)
INSERT INTO Works_on VALUES(21312332,1,20.0)
INSERT INTO Works_on VALUES(321233765,1,25.0)
INSERT INTO Works_on VALUES(342343434,1,20.0)
INSERT INTO Works_on VALUES(342343434,4,25.0)
INSERT INTO Works_on VALUES(41124234,2,20.0)
INSERT INTO Works_on VALUES(41124234,3,30.0)

--- a)
CREATE PROCEDURE deleteEmployee @Ssn varchar(9)
AS
BEGIN
		DELETE FROM Employee WHERE Ssn = @Ssn; --Delete from employee
		DELETE FROM Works_on WHERE Essn = @Ssn; --Delete from works on
		DELETE FROM Dependent WHERE Essn = @Ssn; --Delete from dependent

		UPDATE Employee SET Super_Ssn = NULL WHERE Super_Ssn = @Ssn; --update if employee was manager
		UPDATE Department SET Mgr_Ssn = NULL WHERE Mgr_Ssn = @Ssn  --update if employee was manager of deaprtment
	COMMIT;
END

EXEC deleteEmployee '183623612';

Select * from Employee
Select * from Department
Select * from Dependent
Select * from Project
Select * from Works_on

DROP PROCEDURE deleteEmployee

--- b)

CREATE PROCEDURE dbo.DepartmentManagers
AS
BEGIN
  SELECT Ssn, Fname, Lname,Dname,Mgr_start_date
    FROM Department as d
      INNER JOIN employee as e
      ON e.Ssn = d.Mgr_ssn
    ORDER BY d.Mgr_start_date

    SELECT TOP(1) Mgr_start_date, ssn,
           DATEDIFF(year, Mgr_start_date, GETDATE()) AS tempo
      FROM Department as d
        INNER JOIN Employee as e
        ON e.Ssn = d.Mgr_ssn
      ORDER BY d.Mgr_start_date
END
GO

--- c)

CREATE TRIGGER Check_Mult_Managers ON Department
AFTER INSERT, UPDATE
	AS

		IF EXISTS(SELECT Mgr_ssn
				  FROM Company.Department
				  WHERE Mgr_ssn IS NOT NULL)
			BEGIN 
				RAISERROR ('Employee is already the manager of a department',16,1); 
				ROLLBACK TRAN;                                               
			END 
	GO

INSERT INTO Department VALUES ('My Dept3',1222,'21312332','2018-01-01') --trigger  RaiseError

Select * from Department

DROP TRIGGER Check_Mult_Managers

--- d)

CREATE TRIGGER verifySalary ON Employee
AFTER INSERT, UPDATE
AS
    DECLARE @mng_salary as decimal(6,2);
	DECLARE @emp_salary as decimal(6,2);
	DECLARE @emp_ssn as char(12);

	SELECT @emp_salary = Salary, @emp_ssn = Ssn FROM inserted;

    SELECT @mng_salary = Employee.Salary
	  FROM Employee
			JOIN INSERTED ON Employee.Ssn = INSERTED.Super_ssn;

    IF @emp_salary > @mng_salary
    BEGIN
			UPDATE Employee
			SET Salary = @emp_salary
			WHERE Employee.Ssn = @emp_ssn;
    END
GO

--- e)

CREATE FUNCTION getProjLocatiob (@Ssn VARCHAR(9)) RETURNS TABLE
AS
	RETURN (SELECT Pname, Plocation
			FROM Project JOIN (Works_on JOIN Employee ON Essn = Ssn) ON Pnumber = Pno
			WHERE Employee.Ssn = @Ssn);

SELECT * 
FROM getProjLocatiob ('342343434')

DROP FUNCTION getProjLocatiob

--- f)

CREATE FUNCTION FuncDno (@dno int = 0)
RETURNS TABLE
AS
    RETURN
	(
	SELECT Employee.*
	  FROM Employee
	 WHERE Employee.Dno = @dno
	   AND Employee.Salary > (
	   		SELECT AVG(E.Salary) as Sal_medio
			  FROM Employee E
			 WHERE E.Dno = @dno
		  GROUP BY E.Dno	
		)
	);
GO

--- g)

DROP FUNCTION Budget
GO

GO
CREATE FUNCTION Budget(@dno int) RETURNS @projtable TABLE (pname varchar(15), number int, plocation varchar(15), dnum int, budget decimal(10,2), totalbudget decimal(10,2))
AS
BEGIN

	DECLARE @pname as varchar(15), @number as int, @plocation as varchar(15), @dnum as int, @budget as decimal(10,2), @totalbudget as decimal(10,2);

	DECLARE C CURSOR FAST_FORWARD
	FOR SELECT Pname, Pnumber, Plocation, Dnumber, Sum(Salary*[Hours]/(40*4))
		FROM	DEPARTMENT 
				JOIN PROJECT ON Dnumber=Dnum
				JOIN Works_on ON Pnumber=Pno
				JOIN EMPLOYEE ON Essn=Ssn
		WHERE Dnumber=@dno
		GROUP BY Pname, Pnumber, Plocation, Dnumber;

	OPEN C;

	FETCH C INTO @pname, @number, @plocation, @dnum, @budget;
	SELECT @totalbudget = 0;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @totalbudget += @budget;
		INSERT INTO @projtable VALUES (@pname, @number, @plocation, @dnum, @budget, @totalbudget)
		FETCH C INTO @pname, @number, @plocation, @dnum, @budget;
	END

	CLOSE C;

	DEALLOCATE C;

	return;
END
GO

	SELECT * 
FROM Budget (3);
GO

--- h)

CREATE TRIGGER DepDelete ON Department
AFTER DELETE
AS
BEGIN
	IF NOT (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'department_deleted'))
		BEGIN
		CREATE TABLE department_deleted(
			Dname varchar(50) not null,
			Dnumber int PRIMARY KEY,
			Mgr_ssn char(12),
			Mgr_start_date DATE
		);
		END
    INSERT INTO dbo.department_deleted
    SELECT * FROM DELETED
END
GO

--- i)

/*Começando pelas diferenças: Uma UDF tem sempre que retornar um valor enquanto que uma Stored Procedure não.
Uma Stored procedure é apenas compilada uma vez podendo ser reutilizada, uma vez que fica guardada na memória. Já uma UDF é compilada sempre que é utilizada.
Numa procedure é possível fazer exception-handling o que não acontece numa UDF.
Numa procedure podemos usar variáveis temporárias e tabelas, enquanto a UDF não permite tabelas temporárias.
Uma procedure pode ter parâmetros de input e output, numa UDF apenas são permitimos de input.
Ambas as ferramentas permitem simplificar, limpar e otimizar o código SQL.*/