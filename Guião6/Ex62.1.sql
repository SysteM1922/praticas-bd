-- 5.1
-- 6.2 a)
create table Employee (
	Fname		varchar(15)		not null,
	Minit		char(1)					,
	Lname		varchar(15)		not null,
	Ssn			char(9)			not null,
	Bdate		date,
	[Address]	varchar(30),
	Sex			char(1)			not null,
	Salary		decimal(6,2)	not null,
	Super_ssn	char(9),
	Dno			int				not null
	
	primary key (Ssn)			
);

create table Department(
	Dname			varchar(30)		not null,
	Dnumber			int				not null,
	Mgr_Ssn			char(9)					,
	Mgr_start_date	date,

	primary key (Dnumber)
);

create table Dept_locations(
	Dnumber		int			not null,
	Dlocation	varchar(15)	not null

	primary key (Dnumber,Dlocation)
);

create table Project(
	Pname		varchar(30)		not null,
	Pnumber		int				not null,
	Plocation	varchar(15)		not null,
	Dnum		int				not null,

	primary key (Pnumber)
);

create table Works_on(
	Essn	char(9)			not null,
	Pno		int				not null,
	[Hours]	decimal(3,1)	not null,

	primary key (Essn,Pno)
);

create table [Dependent](
	Essn			char(9)		not null,
	Dependent_name	varchar(30)	not null,
	Sex				char(1)		not null,
	Bdate			date				,
	Relationship	varchar(15)	not null

	primary key (Essn,Dependent_name)
);


alter table Employee add constraint employeeSuper foreign key (Super_ssn) references Employee (Ssn);
alter table Employee add constraint employeeDept foreign key (Dno) references Department (Dnumber);
alter table Dept_locations add constraint deptLocDpet foreign key (Dnumber) references Department (Dnumber);
alter table Project add constraint projcetDpet foreign key (Dnum) references Department (Dnumber);
alter table Works_on add constraint worksProject foreign key (Pno) references Project (Pnumber);
alter table Works_on add constraint worksEmployee foreign key (Essn) references Employee (Ssn);
alter table [Dependent] add constraint dependentEmployee foreign key (Essn) references Employee (Ssn);


-- 6.2 b)
insert into Department values ('Investigacao',1,'21312332','2010-08-02');
insert into Department values ('Comercial',2,'321233765','2013-05-16');
insert into Department values ('Logistica',3,'41124234','2013-05-16');
insert into Department values ('Recursos Humanos',4,'12652121','2014-04-02');
insert into Department values ('Desporto',5,NULL,NULL);

insert into Employee values ('Paula','A','Sousa','183623612','2001-08-11','Rua da FRENTE','F',1450.00,NULL,3);
insert into Employee values ('Carlos','D','Gomes','21312332','2000-01-01','Rua XPTO','M',1200.00,NULL,1);
insert into Employee values ('Juliana','A','Amaral','321233765','1980-08-11','Rua BZZZZ','F',1350.00,NULL,3);
insert into Employee values ('Maria','I','Pereira','342343434','2001-05-01','Rua JANOTA','F',1250.00,'21312332',2);
insert into Employee values ('Joao','G','Costa','41124234','2001-01-01','Rua YGZ','M',1300.00,'21312332',2);
insert into Employee values ('Ana','L','Silva','12652121','1990-03-03','Rua ZIG ZAG','F',1400.00,'21312332',2);

insert into [Dependent] values ('21312332' ,'Joana Costa','F','2008-04-01', 'Filho');
insert into [Dependent] values ('21312332' ,'Maria Costa','F','1990-10-05', 'Neto');
insert into [Dependent] values ('21312332' ,'Rui Costa','M','2000-08-04','Neto');
insert into [Dependent] values ('321233765','Filho Lindo','M','2001-02-22','Filho');
insert into [Dependent] values ('342343434','Rosa Lima','F','2006-03-11','Filho');
insert into [Dependent] values ('41124234' ,'Ana Sousa','F','2007-04-13','Neto');
insert into [Dependent] values ('41124234' ,'Gaspar Pinto','M','2006-02-08','Sobrinho');

insert into Dept_locations values (2,'Aveiro');
insert into Dept_locations values (3,'Coimbra');

insert into Project values ('Aveiro Digital',1,'Aveiro',3);
insert into Project values ('BD Open Day',2,'Espinho',2);
insert into Project values ('Dicoogle',3,'Aveiro',3);
insert into Project values ('GOPACS',4,'Aveiro',3);

insert into Works_on values ('183623612',1,20.0);
insert into Works_on values ('183623612',3,10.0);
insert into Works_on values ('21312332' ,1,20.0);
insert into Works_on values ('321233765',1,25.0);
insert into Works_on values ('342343434',1,20.0);
insert into Works_on values ('342343434',4,25.0);
insert into Works_on values ('41124234' ,2,20.0);
insert into Works_on values ('41124234' ,3,30.0);

-- 6.2 c)
-- a)
select Ssn, Fname, Minit, Lname, Pno
from (Employee join Works_on on Ssn=Essn);

-- b)
select E.Fname, E.Minit, E.Lname
from (Employee as E join Employee as S on E.Super_ssn=S.Ssn)
where S.Fname='Carlos' and S.Minit='D' and S.Lname='Gomes';

-- c)
select Pname, sum([Hours]) as Total_hours
from (Project join Works_on on Pnumber=Pno)
group by Pname;

-- d)
select Fname,Minit,Lname
from ((Project join Works_on on Pnumber=Pno) join Employee on Ssn=Essn)
where Hours>20 and Dno=3;

-- e)
select Fname,Minit,Lname
from (Employee left outer join Works_on on Ssn=Essn)
where Essn is null

-- f)
select Dname, avg(Salary) as Avg_salary
from (Department join Employee on Dno=Dnumber)
where Sex='F'
group by Dname;

-- g)
select Fname, Minit, Lname, count(Dependent_name) as DependentsNumber
from (Employee join [Dependent] on Ssn=Essn)
group by  Fname, Minit, Lname
having count(Dependent_name) > 2;

-- h)
select Fname, Minit, Lname
from ((Employee join Department on Ssn=Mgr_ssn) left outer join [Dependent] on Ssn=Essn)
where Essn is null

-- i)
select distinct Fname, Minit,Lname,[Address]
from (((Works_on join Employee on Ssn=Essn) join Project on Pno=Pnumber) join Dept_locations on Dno=Dnumber)
where Plocation='Aveiro' and Dlocation!='Aveiro'