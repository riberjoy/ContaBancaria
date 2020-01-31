--CREATE DATABASE [ContaBancaria]
USE ContaBancaria

	/*
	Documentação
	Arquivo Fonte.....: ContaBancaria.sql
	Objetivo..........: Criar o BD e as tabelas: conta, operação e cliente
	Autora............: Joyce Ribeiro
 	Data..............: 22/01/2020
	Comentários.......: Tipos de contas:
						1 - Conta corrente
						2 - Conta polpança
	*/

IF OBJECT_ID (N'dbo.Conta', N'FN') IS NULL   
CREATE  TABLE Conta(
		Num_ContaID		int				identity,
		Num_Conta		int				NOT NULL,
		Num_Agencia		int				NOT NULL,
		Nom_banco		varchar(100)	NOT NULL,
		Dat_AbertConta	dateTime		NOT NULL,
		Vlr_Saldo		money			NOT NULL,
		
		CONSTRAINT PK_Num_ContaID PRIMARY KEY (Num_ContaID),
)

IF OBJECT_ID (N'dbo.Cliente', N'FN') IS NULL 
CREATE  TABLE Cliente(
		Num_Cliente		int				identity,
		Nom_Cliente		varchar(150)	NOT NULL,
		Dat_Nasc		datetime		NOT NULL,
		Num_Cpf			varchar(11)		NOT NULL,
		Ind_Sexo		char(1)			NOT NULL,
		Num_Telefone	varchar(8)			NULL,
		Num_Celular		varchar(9)			NULL,
		Num_ContaID		int					NULL,
		
		CONSTRAINT PK_Num_Cliente PRIMARY KEY (Num_Cliente),
		CONSTRAINT FK_Num_ContaID FOREIGN KEY (Num_ContaID) REFERENCES Conta(Num_ContaID)
)

IF OBJECT_ID (N'dbo.Operacao', N'FN') IS NULL 
CREATE  TABLE  Operacao(
		Num_Operacao	int				identity,
		Ind_Operacao	char(1)			NOT NULL,
		Vlr_Operacao	money			NOT NULL,
		Dat_Operacao	dateTime		NOT NULL,
		Num_Conta2		int					NULL,
		Num_Cliente		int				NOT NULL,

		CONSTRAINT PK_Num_Operacao PRIMARY KEY (Num_Operacao),
		CONSTRAINT FK_Num_Cliente FOREIGN KEY (Num_Cliente) REFERENCES Cliente(Num_Cliente)
)