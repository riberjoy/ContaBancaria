IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[InsCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[InsCliente] 
GO 

CREATE PROCEDURE [dbo].[InsCliente](
	@Nom_Cliente	varchar(150),
	@Dat_Nasc		datetime,
	@Num_Cpf		varchar(11),
	@Ind_Sexo		char(1),
	@Num_Telefone	varchar(8),
	@Num_Clelular	varchar(9),
	@Num_Conta		int	
	)

	AS

	/*
		Documenta��o
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Cadastra um novo cliente no sistema
		Autor.............: Joyce Ribeiro
 		Data..............: 23/01/2020
		Coment�rios.......: Par�metro Status :
							0 - Processado OK
							1 - Erro ao inserir
	*/

	BEGIN 
		IF (SELECT COUNT(*) FROM Cliente WHERE Num_Cpf = @Num_Cpf) = 0
			BEGIN
				INSERT  INTO Cliente (Nom_Cliente, Dat_Nasc, Num_Cpf, Ind_Sexo, 
						Num_Telefone, Num_Celular, Num_ContaID)
					VALUES (@Nom_Cliente, @Dat_Nasc, @Num_Cpf, @Ind_Sexo, 
						@Num_Telefone, @Num_Clelular, (SELECT Num_ContaID FROM Conta WHERE Num_Conta = @Num_Conta) )
				RETURN 0
			END
		ELSE
			BEGIN
				PRINT 'Cliente n�o pode ser cadastrado'
			END
	END 
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[AltCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[AltCliente] 
GO 

CREATE PROCEDURE [dbo].[AltCliente](
	@Nom_Cliente	varchar(150),
	@Dat_Nasc		datetime,
	@Num_Cpf		varchar(12),
	@Ind_Sexo		char(1),
	@Num_Telefone	varchar(8),
	@Num_Celular	varchar(9),
	@Num_Conta		int	
	)

	AS
	/*
		Documenta��o
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Altera um cliente existente
		Autor.............: Joyce Ribeiro
 		Data..............: 24/01/2020
		Coment�rios.......: Par�metro Status :
							0 - Processado OK
							1 - Erro ao alterar
		Ex................: EXEC [dbo].[GKSSP_SelSolicAbonos] 30004644, 2018, 10, '0'
	*/

	BEGIN
		UPDATE  Cliente 
			SET Cliente.Nom_Cliente = @Nom_Cliente, 
				Cliente.Dat_Nasc = @Dat_Nasc,
				Cliente.Ind_Sexo = @Ind_Sexo, 
				Cliente.Num_Telefone = @Num_Telefone, 
				Cliente.Num_Celular =  @Num_Celular,
				Cliente.Num_ContaID = (SELECT Num_ContaID FROM Conta WHERE Num_Conta = @Num_Conta)
			WHERE Cliente.Num_Cpf = @Num_Cpf
		RETURN 0
	END 
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DelCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[DelCliente] 
GO 

CREATE PROCEDURE [dbo].[DelCliente](
	@Num_Cpf	varchar(11))

	AS
	/*
		Documenta��o
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Remove um determinado cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 24/01/2020
		Coment�rios.......: Par�metro Status :
							0 - Processado OK
							1 - Erro ao excluir
		Ex................: EXEC [dbo].[GKSSP_SelSolicAbonos] 30004644, 2018, 10, '0'
	*/

	BEGIN
		DELETE FROM Cliente 
			WHERE Cliente.Num_Cpf = @Num_Cpf
		RETURN 0
	END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SelCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[SelCliente] 
GO 

CREATE PROCEDURE [dbo].[SelCliente](
	@Num_Cpf	varchar(11) )

	AS
	/*
		Documenta��o
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Seleciona todos os clientes
		Autor.............: Joyce Ribeiro
 		Data..............: 24/01/2020
		Coment�rios.......: Par�metro Status :
							0 - Processado OK
							1 - Erro ao selecionar
		Ex................: EXEC [dbo].[GKSSP_SelSolicAbonos] 30004644, 2018, 10, '0'
	*/

	BEGIN
		IF @Num_Cpf = '0'
			BEGIN
				SELECT 
					Nom_Cliente,
					Dat_Nasc,
					Num_Cpf, 
					Ind_Sexo, 
					Num_Telefone, 
					Num_Celular,
					Num_ContaID 
				FROM Cliente WITH(NOLOCK)
			END
		ELSE
			BEGIN
				SELECT 
					Nom_Cliente,
					Dat_Nasc,
					Num_Cpf, 
					Ind_Sexo, 
					Num_Telefone, 
					Num_Celular,
					Num_ContaID 
				FROM Cliente cl WITH(NOLOCK)
				WHERE cl.Num_Cpf = @Num_Cpf
			END

		RETURN 0
	END
GO