CREATE TABLE Pessoa(
	ID INT NOT NULL PRIMARY KEY,
	Email VARCHAR(32) NOT NULL,
	Nome VARCHAR(32) NOT NULL,
);

CREATE TABLE Conferencia(
	ID INT NOT NULL PRIMARY KEY,
	IDPessoa INT NOT NULL FOREIGN KEY REFERENCES Pessoa(ID),
);

CREATE TABLE Participante(
	Morada VARCHAR(256) NOT NULL,
	DataInscricao DATE NOT NULL,
	IDPessoa INT NOT NULL REFERENCES Pessoa(ID),
	PRIMARY KEY(IDPessoa),
);

CREATE TABLE Instituicao(
	ID INT NOT NULL PRIMARY KEY,
	Nome VARCHAR(32) NOT NULL,
	Endereco VARCHAR(256) NOT NULL,
);

CREATE TABLE ArtigoCientifico(
	NumeroRegisto INT NOT NULL PRIMARY KEY,
	Titulo VARCHAR(64) NOT NULL,
	IDConferencia INT FOREIGN KEY REFERENCES Conferencia(ID),
);

CREATE TABLE Autor(
	IDIntituicao INT NOT NULL FOREIGN KEY REFERENCES Instituicao(ID),
	IDPessoa INT NOT NULL REFERENCES Pessoa(ID),
	PRIMARY KEY(IDPessoa),
);

CREATE TABLE Autoria(
	IDAutor INT NOT NULL FOREIGN KEY REFERENCES Autor(IDPEssoa),
	IDArtigoCientifico INT NOT NULL FOREIGN KEY REFERENCES ArtigoCientifico(NumeroRegisto),
	PRIMARY KEY(IDAutor, IDArtigoCientifico),
);

CREATE TABLE NaoEstudante(
	ReferenciaTransacao VARCHAR(64) NOT NULL,
	IDParticipante INT NOT NULL REFERENCES Participante(IDPessoa),
	PRIMARY KEY(IDParticipante),
);

CREATE TABLE Estudante(
	Instituicao INT NOT NULL FOREIGN KEY REFERENCES Instituicao(ID),
	ComprovativoInscricao VARCHAR(32) NOT NULL,
	IDParticipante INT NOT NULL REFERENCES Participante(IDPessoa),
	PRIMARY KEY(IDParticipante),
);

