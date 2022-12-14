CREATE TABLE Paciente(
	NumeroUtente INT NOT NULL PRIMARY KEY,
	Enderenco VARCHAR(256) NOT NULL,
	Nome VARCHAR(64) NOT NULL,
	DataNascimento DATE NOT NULL, 
);

CREATE TABLE Medico(
	ID INT NOT NULL PRIMARY KEY,
	Nome VARCHAR(64) NOT NULL,
	Especialidade VARCHAR(64),
);

CREATE TABLE Farmaceutica(
	NumeroRegistoNacional INT NOT NULL PRIMARY KEY,
	Nome VARCHAR(32) NOT NULL,
	Endereco VARCHAR(256) NOT NULL,
	Telefone INT NOT NULL,
);

CREATE TABLE Farmacia(
	ID INT NOT NULL PRIMARY KEY,
	NIF INT NOT NULL,
	Endereco VARCHAR(256) NOT NULL,
	Nome VARCHAR(32) NOT NULL,
	Telefone INT NOT NULL,
);

CREATE TABLE Farmaco(
	ID INT NOT NULL PRIMARY KEY,
	Formula VARCHAR(256) NOT NULL,
	NomeComercial VARCHAR(32),
	IDFarmaceutica INT NOT NULL FOREIGN KEY REFERENCES Farmaceutica(NumeroRegistoNacional),
	IDFarmacia INT NOT NULL FOREIGN KEY REFERENCES Farmacia(ID),
);

CREATE TABLE Prescricao(
	NumeroUnico INT NOT NULL PRIMARY KEY,
	[Data] DATE NOT NULL,
	IDPaciente INT FOREIGN KEY REFERENCES Paciente(NumeroUtente),
	IDFarmaco INT NOT NULL FOREIGN KEY REFERENCES Farmaco(ID),
	IDFarmacia INT NOT NULL FOREIGN KEY REFERENCES Farmacia(ID),
	IDMedico INT NOT NULL FOREIGN KEY REFERENCES Medico(ID),
);