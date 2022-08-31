
CREATE TABLE Empresa (
    ID INT NOT NULL PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
);


CREATE TABLE Armazem (
    ID INT NOT NULL PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	Preco FLOAT NOT NULL,
	IVA FLOAT NOT NULL,
    Designacao VARCHAR(50) NOT NULL,
	IDEmpresa	INT FOREIGN KEY REFERENCES Empresa(ID),
);

CREATE TABLE Produto(
	Codigo INT NOT NULL PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    IVA FLOAT NOT NULL,
    Preco FLOAT NOT NULL,
);

CREATE TABLE ArmazemProduto (
    IDArmazem INT NOT NULL,
	IDProduto INT NOT NULL,

    PRIMARY KEY (IDArmazem, IDProduto),
	FOREIGN KEY (IDProduto) REFERENCES Armazem(ID),
	FOREIGN KEY (IDProduto) REFERENCES Produto(Codigo)
);

CREATE TABLE TipoFornecedor (
    CodigoInterno INT NOT NULL PRIMARY KEY,
	Designação VARCHAR(50) NOT NULL,
);

CREATE TABLE Fornecedor (
    ID INT NOT NULL PRIMARY KEY,
	Nome VARCHAR(50) NOT NULL,
	NIF INT NOT NULL,
	endereco VARCHAR(50) NOT NULL,
	FAX VARCHAR(50),
	OpcoesPagamento VARCHAR(50) NOT NULL,
    Tipo INT NOT NULL FOREIGN KEY REFERENCES TipoFornecedor(CodigoInterno),
);

CREATE TABLE Encomenda (
    ID INT NOT NULL PRIMARY KEY,
	[Data] DATE NOT NULL,
	IDFornecedor INT NOT NULL FOREIGN KEY REFERENCES Fornecedor(ID),
);

CREATE TABLE EncomendaProduto (
    IDEncomenda INT NOT NULL,
	IDProduto INT NOT NULL,
    
    PRIMARY KEY (IDEncomenda, IDProduto),
    FOREIGN KEY (IDProduto) REFERENCES Produto(Codigo),
    FOREIGN KEY (IDEncomenda) REFERENCES Encomenda(ID)
);

