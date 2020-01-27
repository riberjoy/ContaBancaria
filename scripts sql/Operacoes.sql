IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[InsSaque]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[InsSaque] 
GO 

CREATE PROCEDURE [dbo].[InsSaque](
	@Vlr_Operacao	money,		
	@Num_Cliente	int)

	AS

	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Realiza um saque na conta de um cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 27/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao inserir
							2 - Saldo insuficiente para completar a operação

							Id operação:
							1 - Saque
							2 - Deposito
							3 - Transferencia
							4 - Estorno
							5 - Extrato
	*/

	BEGIN 
		DECLARE @valorEmConta	money
		SET @valorEmConta = CASE WHEN (SELECT Vlr_Saldo 
									FROM Conta ct WITH(NOLOCK) 
									INNER JOIN Cliente cl 
									ON cl.Num_Cliente = @Num_Cliente) >= 
									@Vlr_Operacao THEN (SELECT Vlr_Saldo 
															FROM Conta ct WITH(NOLOCK) 
															INNER JOIN Cliente cl 
															ON cl.Num_Cliente = @Num_Cliente) ELSE NULL END

		IF @valorEmConta <> NULL			
			BEGIN
				INSERT INTO Operacao( Ind_Operacao, Vlr_Operacao,
						Dat_Operacao, Num_Conta2, Num_Cliente)
					VALUES ('1', @Vlr_Operacao, GETDATE(), NULL, @Num_Cliente)

				UPDATE  Conta
					SET Conta.Vlr_Saldo	= (@valorEmConta - @Vlr_Operacao)
					WHERE Conta.Num_Conta = (SELECT Num_Conta 
												FROM Cliente cl WITH(NOLOCK)
												WHERE cl.Num_Cliente = @Num_Cliente)

				RETURN 0
			END
		ELSE
			BEGIN
				RETURN 2
			END

	END 
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[InsDeposito]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[InsDeposito] 
GO 

CREATE PROCEDURE [dbo].[InsDeposito](
	@Vlr_Operacao	money,	
	@Num_Cliente	int 
	)

	AS

	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Realiza deposito na conta de um cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 27/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao realizar deposito

							Id operação:
							1 - Saque
							2 - Deposito
							3 - Transferencia
							4 - Estorno
							5 - Extrato
	*/

	BEGIN 
		INSERT INTO Operacao( Ind_Operacao, Vlr_Operacao,
				Dat_Operacao, Num_Conta2, Num_Cliente)
			VALUES ('2', @Vlr_Operacao, GETDATE(), NULL, @Num_Cliente)

		UPDATE  Conta
			SET Conta.Vlr_Saldo	= (Conta.Vlr_Saldo + @Vlr_Operacao)
			WHERE Conta.Num_Conta = (SELECT Num_Conta 
										FROM Cliente cl WITH(NOLOCK)
										WHERE cl.Num_Cliente = @Num_Cliente)

		RETURN 0
	
	END 
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[InsTransferencia]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[InsTransferencia] 
GO 

CREATE PROCEDURE [dbo].[InsTransferencia](
	@Vlr_Operacao	money,
	@Num_Cliente	int,
	@Num_Conta2		int
	)

	AS

	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Realiza uma transferencia para outro cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 27/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao inserir
							2 - Erro ao realizar transferencia

							Id operação:
							1 - Saque
							2 - Deposito
							3 - Transferencia
							4 - Estorno
							5 - Extrato
	*/

	BEGIN 
		DECLARE @valorEmConta	money
		SET @valorEmConta = CASE WHEN (SELECT Vlr_Saldo 
									FROM Conta ct WITH(NOLOCK) 
									INNER JOIN Cliente cl 
									ON cl.Num_Cliente = @Num_Cliente) >= 
									@Vlr_Operacao THEN (SELECT Vlr_Saldo 
															FROM Conta ct WITH(NOLOCK) 
															INNER JOIN Cliente cl 
															ON cl.Num_Cliente = @Num_Cliente) ELSE NULL END

		IF @valorEmConta <> NULL			
			BEGIN
				INSERT INTO Operacao( Ind_Operacao, Vlr_Operacao,
						Dat_Operacao, Num_Conta2, Num_Cliente)
					VALUES ('3', @Vlr_Operacao, GETDATE(), NULL, @Num_Cliente)

				--DEBITA VALOR DA TRANSFERENCIA DA RESPONSAVEL PELA TRANSFERENCIA
				UPDATE  Conta
					SET Conta.Vlr_Saldo	= (@valorEmConta - @Vlr_Operacao)
					WHERE Conta.Num_Conta = (SELECT Num_Conta 
												FROM Cliente cl WITH(NOLOCK)
												WHERE cl.Num_Cliente = @Num_Cliente)

				-- INSERE VALOR DA TRANSFERENCIA PARA A SEGUNDA CONTA
				UPDATE  Conta
					SET Conta.Vlr_Saldo	= (Conta.Vlr_Saldo + @Vlr_Operacao)
					WHERE Conta.Num_Conta = (SELECT Num_Conta 
												FROM Cliente cl WITH(NOLOCK)
												WHERE cl.Num_Cliente = @Num_Conta2)
				RETURN 0
			END
		ELSE
			BEGIN
				RETURN 2
			END

	END 
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[InsEstorno]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[InsEstorno] 
GO 

CREATE PROCEDURE [dbo].[InsEstorno](
	@Num_Operacao	int,
	@Num_Cliente	int 
	)

	AS

	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Realiza o estorno para a conta de um cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 27/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao inserir

							Id operação:
							1 - Saque
							2 - Deposito
							3 - Transferencia
							4 - Estorno
							5 - Extrato
	*/

	BEGIN
		IF (SELECT Ind_Operacao FROM Operacao op WHERE op.Num_Operacao = @Num_Operacao) IN ('2', '3')
			BEGIN
				DECLARE @ValorCreditar  money,
						@Conta2			int

				SET @ValorCreditar = (SELECT Vlr_Operacao FROM Operacao op WHERE op.Ind_Operacao = @Num_Operacao)
				SET	@Conta2 = (SELECT Num_Conta2 FROM Operacao op WHERE op.Ind_Operacao = @Num_Operacao)

				INSERT INTO Operacao( Ind_Operacao, Vlr_Operacao,
						Dat_Operacao, Num_Conta2, Num_Cliente)
					VALUES ('4', @ValorCreditar, GETDATE(), NULL, @Num_Cliente)

				UPDATE  Conta
					SET Conta.Vlr_Saldo	= (Conta.Vlr_Saldo + @ValorCreditar)
					WHERE Conta.Num_Conta = @Num_Cliente
					
				UPDATE  Conta
					SET Conta.Vlr_Saldo	= (Conta.Vlr_Saldo - @ValorCreditar)
					WHERE Conta.Num_Conta = @Conta2

			END
		RETURN 0
	END 
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'[dbo].[SelExtrato]') AND objectproperty(id, N'IsPROCEDURE')=1)
	DROP PROCEDURE [dbo].[SelExtrato] 
GO 

CREATE PROCEDURE [dbo].[SelExtrato](	
	@Num_Cliente	int 
	)

	AS

	/*
		Documentação
		Arquivo Fonte.....: Cliente.sql
		Objetivo..........: Realiza o extrato da conta do Cliente
		Autor.............: Joyce Ribeiro
 		Data..............: 27/01/2020
		Comentários.......: Parâmetro Status :
							0 - Processado OK
							1 - Erro ao Retornar as operações realizadas por um cliente
	*/

	BEGIN 
		SELECT Ind_Operacao,
			   Vlr_Operacao,
			   Dat_Operacao,
			   Num_Conta2			   
			FROM Operacao op
			WHERE op.Num_Cliente = @Num_Cliente
			
		RETURN 0
	END 
GO