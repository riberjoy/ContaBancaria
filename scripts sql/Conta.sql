IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[InsContaCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[InsContaCliente] 
GO 

CREATE PROCEDURE [dbo].[InsContaCliente](
	@Num_Agencia		int,
	@Nom_banco			varchar,
	@Ind_TipoConta		char(1),
	@Dat_AbertConta		dateTime,
	@Vlr_Saldo			money
	)

	AS
	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Cadastra a conta de um novo cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 24/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao inserir
		Ex................: EXEC [dbo].[GKSSP_SelSolicAbonos] 30004644, 2018, 10, '0'
	*/

	BEGIN
		INSERT INTO Conta(Num_Agencia, Nom_Banco, Ind_TipoConta, Dat_AbertConta,
				Vlr_Saldo)
			VALUES ( @Num_Agencia, @Nom_banco, @Ind_TipoConta, @Dat_AbertConta,
				@Vlr_Saldo
		)
		RETURN 0

	END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[AltContaCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[AltContaCliente] 
GO 

CREATE PROCEDURE [dbo].[AltContaCliente](
	@Num_Conta			int,
	@Num_Agencia		int,
	@Nom_banco			varchar,
	@Ind_TipoConta		char(1),
	@Dat_AbertConta		dateTime,
	@Vlr_Saldo			money
	)

	AS
	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Altera a conta de um cliente existente
		Autor.............: Joyce Ribeiro
 		Data..............: 24/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao alterar
		Ex................: EXEC [dbo].[GKSSP_SelSolicAbonos] 30004644, 2018, 10, '0'
	*/

	BEGIN
		UPDATE  Conta 
			SET Conta.Num_Agencia = @Num_Agencia,	
				Conta.Nom_banco = @Nom_banco,		
				Conta.Ind_TipoConta	= @Ind_TipoConta,
				Conta.Dat_AbertConta = @Dat_AbertConta,	 
				Conta.Vlr_Saldo	= @Vlr_Saldo
			WHERE Conta.Num_Conta = @Num_Conta
		RETURN 0
	END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[DelContaCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[DelContaCliente] 
GO 

CREATE PROCEDURE [dbo].[DelContaCliente](
	@Num_Conta	int )

	AS
	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Remove a conta de um cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 24/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao excluir
		Ex................: EXEC [dbo].[GKSSP_SelSolicAbonos] 30004644, 2018, 10, '0'
	*/

	BEGIN
		DELETE FROM Conta 
			WHERE Conta.Num_Conta = @Num_Conta
		RETURN 0
	END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SelContaCliente]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[SelContaCliente] 
GO 

CREATE PROCEDURE [dbo].[SelContaCliente](
	@Num_Conta	int )

	AS
	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Seleciona os dados da conta de um cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 24/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao selecionar
		Ex................: EXEC [dbo].[GKSSP_SelSolicAbonos] 30004644, 2018, 10, '0'
	*/

	BEGIN
		BEGIN
			SELECT 
				Num_Conta,		
				Num_Agencia,
				Nom_banco,
				Ind_TipoConta,
				Dat_AbertConta,
				Vlr_Saldo
			FROM Conta WITH(NOLOCK)
			WHERE Conta.Num_Conta = @Num_Conta
		END
		RETURN 0
	END
GO