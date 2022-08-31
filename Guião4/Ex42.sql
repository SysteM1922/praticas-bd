CREATE TABLE Airport(
	Airport_code VARCHAR(32) NOT NULL PRIMARY KEY,
	City VARCHAR(64) NOT NULL,
	[State] VARCHAR(64) NOT NULL,
	[Name] VARCHAR(64) NOT NULL, 
);

CREATE TABLE Airplane_Type(
	[Type_name] VARCHAR(64) NOT NULL PRIMARY KEY,
	Company VARCHAR(64) NOT NULL,
	Max_seats INT NOT NULL,
);

CREATE TABLE Airplane(
	Airplane_id INT NOT NULL PRIMARY KEY,
	Total_no_of_seats INT NOT NULL,
	Airplane_Type_Type_name VARCHAR(64) NOT NULL FOREIGN KEY REFERENCES Airplane_Type([Type_name]),
);

CREATE TABLE Can_Land(
	Airport_code VARCHAR(32) NOT NULL,
	[Type_name] VARCHAR(64) NOT NULL,

	PRIMARY KEY(Airport_code, [Type_name]),
	FOREIGN KEY(Airport_code) REFERENCES Airport(Airport_code),
	FOREIGN KEY([Type_name]) REFERENCES Airplane_Type([Type_name]),
);

CREATE TABLE Leg_Instance(
	[Date] DATE NOT NULL PRIMARY KEY,
	No_of_avail_seats INT NOT NULL,
	Airplane_id INT NOT NULL FOREIGN KEY REFERENCES Airplane(Airplane_id),
);

CREATE TABLE Seat(
	Seat_no VARCHAR(5) NOT NULL PRIMARY KEY,
	Customer_name VARCHAR(64) NOT NULL,
	Cphone INT NOT NULL,

	Leg_Instance_Date DATE NOT NULL FOREIGN KEY REFERENCES Leg_Instance([Date]),
);

CREATE TABLE Flight(
	[Number] INT NOT NULL PRIMARY KEY,
	Airline VARCHAR(64) NOT NULL,
	Weekdays VARCHAR(256) NOT NULL,
);

CREATE TABLE Flight_Leg(
	leg_no INT NOT NULL PRIMARY KEY,
	departure_airport VARCHAR(32) NOT NULL FOREIGN KEY REFERENCES Airport(Airport_code),
	arrival_airport VARCHAR(32) NOT NULL FOREIGN KEY REFERENCES Airport(Airport_code),
	scheduled_dep_time TIME NOT NULL,
	scheduled_arr_time TIME NOT NULL,
	Flight_Number INT NOT NULL FOREIGN KEY REFERENCES Flight([Number]),
);

CREATE TABLE Fare(
	Code VARCHAR(32) NOT NULL PRIMARY KEY,
	Amount INT NOT NULL,
	Restrictions VARCHAR(256) NOT NULL,
	Flight_Number INT NOT NULL FOREIGN KEY REFERENCES Flight([Number]),
);