CREATE TABLE Cliente(
	NIF INT NOT NULL PRIMARY KEY,
	nome VARCHAR(256) NOT NULL,
	endereco VARCHAR(1024) NOT NULL,
	num_carta INT NOT NULL,
);

CREATE TABLE Balcao(
	numero INT NOT NULL PRIMARY KEY,
	nome VARCHAR(256) NOT NULL,
	endereco VARCHAR(1024) NOT NULL,
);

CREATE TABLE Tipo_Veiculo(
	codigo VARCHAR(32) NOT NULL PRIMARY KEY,
	arcondicionado BIT NOT NULL,
	designacao VARCHAR(256) NOT NULL,
);

CREATE TABLE Veiculo(
	matricula VARCHAR(8) NOT NULL PRIMARY KEY,
	ano INT NOT NULL,
	marca VARCHAR(256),
	Tipo_Veiculo_codigo VARCHAR(32) NOT NULL FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
);

CREATE TABLE Aluguer(
	numero INT NOT NULL PRIMARY KEY,
	duracao INT NOT NULL,
	[data] DATE NOT NULL,
	Cliente_NIF INT NOT NULL FOREIGN KEY REFERENCES Cliente(NIF),
	Balcao_numero INT NOT NULL FOREIGN KEY REFERENCES Balcao(numero),
	Veiculo_matricula VARCHAR(8) NOT NULL FOREIGN KEY REFERENCES Veiculo(matricula),
);

CREATE TABLE Ligeiro(
	numlugares INT NOT NULL,
	portas INT NOT NULL,
	combustivel VARCHAR(32) NOT NULL,
	Tipo_Veiculo_codigo VARCHAR(32) NOT NULL REFERENCES Tipo_Veiculo(codigo),
	PRIMARY KEY(Tipo_Veiculo_codigo),
);

CREATE TABLE Pesado(
	peso FLOAT NOT NULL,
	passageiros INT NOT NULL,
	Tipo_Veiculo_codigo VARCHAR(32) NOT NULL REFERENCES Tipo_Veiculo(codigo),
	PRIMARY KEY(Tipo_Veiculo_codigo),
);

CREATE TABLE Similaridade(
	PRIMARY KEY(Tipo_Veiculo_codigo1, Tipo_Veiculo_codigo2),
	Tipo_Veiculo_codigo1 VARCHAR(32) NOT NULL FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
	Tipo_Veiculo_codigo2 VARCHAR(32) NOT NULL FOREIGN KEY REFERENCES Tipo_Veiculo(codigo),
);