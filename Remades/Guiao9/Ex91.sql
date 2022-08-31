--a)
CREATE PROCEDURE deleteEmployee @Ssn varchar(9)
AS
	BEGIN
		DELETE FROM Employee WHERE Ssn = @Ssn;
		DELETE FROM Works_on WHERE Essn = @Ssn;
		DELETE FROM DDependent WHERE Essn = @Ssn;
	END
GO

--b)
CREATE PROCEDURE gestores
AS
	BEGIN
		SELECT CONCAT(Fname, ' ', Lname) AS Name FROM (Department JOIN Employee ON Employee.Ssn = Department.Mgr_Ssn)

		SELECT TOP(1) Ssn, DATEDIFF(year,Department.Mgr_start_date,GETDATE()) AS Tempo FROM (Department JOIN Employee ON Employee.Ssn = Department.Mgr_Ssn)
	END
GO

--c)
CREATE TRIGGER checkGestDep ON Department
AFTER INSERT, UPDATE
AS
	IF EXISTS(SELECT Mgr_Ssn FROM Department WHERE Mgr_Ssn IS NOT NULL)
		BEGIN 
			RAISERROR ('Employee is already the manager of a department',16,1); 
			ROLLBACK TRAN;                                              
		END
GO

--d)
CREATE TRIGGER checkGestDep ON Employee
AFTER INSERT, UPDATE
AS
	DECLARE @emp_salary decimal(6, 2)
	DECLARE @emp_ssn char(12)
	DECLARE @mgr_salary decimal(6, 2)

	SELECT @emp_salary=Salary, @emp_ssn=Ssn FROM inserted
	SELECT @mgr_salary=Employee.Salary FROM (Employee JOIN inserted ON inserted.Super_ssn=Employee.Ssn)

	IF @emp_ssn >= @mgr_salary
	BEGIN
		UPDATE Employee
		SET Salary= @mgr_salary-1
		WHERE Ssn = @emp_ssn
	END
GO

