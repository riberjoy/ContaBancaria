Use ContaBancaria

Delete  from Cliente
Delete  from Conta
Delete  from Operacao


--Para Conta 
execute InsContaCliente 124578,124,'Banco xx', '15-11-2014',0
execute InsContaCliente 432344,110,'Banco yy', '15-11-2014',36.00
execute InsContaCliente 123423,123,'Banco yy', '15-11-2014',25.00


execute SelContaCliente 123423

execute AltContaCliente 123423, 50.00

execute DelContaCliente 123423

execute SelContaCliente 0



-- Para cliente
Execute InsCliente 'Joyce', '15-11-1997', '12794266675','F', null, null, null
Execute InsCliente 'Amanda', '15-10-2005', '11111111111','F', null, 998368541, null
Execute InsCliente 'Paulo', '10-10-2010', '22222222222','F', null, null, 124578
Execute InsCliente 'João', '11-11-2011', '00000000000','F', null, null, 123423


execute SelCliente 0
execute SelCliente '22222222222'

execute DelCliente '22222222222'

Execute InsCliente 'Paulo', '10-10-2010', '22222222222','F', null, null, 124578
Execute AltCliente 'João Pedro', '15-12-1994', '22222222222','M', null, null, 124578

Execute AltCliente 'João', '11-11-2011', '00000000000','F', null, null, 432344
execute SelCliente '0'

--Para operações
execute InsSaque 15.00, 00000000000
Select cl.Nom_Cliente, cl.Num_Cpf,ct.Vlr_Saldo from Cliente cl inner join Conta ct on ct.Num_ContaID = cl.Num_ContaID

