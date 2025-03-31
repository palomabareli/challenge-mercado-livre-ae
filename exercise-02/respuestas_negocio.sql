USE `ecommerce-challenge-ml`;


-- 1. Quantos clientes nasceram no dia de hoje e realizaram mais de 1500 vendas em janeiro de 2020?
-- Partindo do pre-suposto de que empresas não fazem aniversário, considerando deste 
-- modo somente clientes do tipo pessoa física.

SELECT c.id_cliente, pf.dt_nascimento, count(*) as qtde_vendas_janeiro_2020
FROM cliente c 
  INNER JOIN cliente_tipo_pessoa ctp 
  	ON c.id_cliente_tipo_pessoa = ctp.id_cliente_tipo_pessoa
  INNER JOIN tipo_pessoa tp 
  	ON ctp.id_tipo_pessoa = tp.id_tipo_pessoa
  INNER JOIN pessoa_fisica pf 
  	ON ctp.id_cliente_tipo_pessoa  = pf.id_cliente_tipo_pessoa	
  	and tp.nome_tipo_pessoa = 'PF'
  	and DAY(pf.dt_nascimento) = DAY(NOW())
  INNER JOIN venda v
  	ON c.id_cliente = v.id_vendedor
  	and MONTH(v.data) =  1
  	and YEAR(v.data) =  2020
 group by c.id_cliente, pf.dt_nascimento
 having count(*) > 3
 ;

-- 2. Liste os 5 vendedores que mais venderam em cada mês de 2020, 
-- considerando o total vendido por mês para a categoria 'Celulares'.

with vendas_por_cliente_mes_2020 AS
(
	SELECT MONTH(v.data) mes_venda, YEAR(v.data) ano_venda,
	count(v.id_venda) qtde_vendas, sum(v.qtde_produto) qtde_produtos,
	sum(v.qtde_produto * e.preco) total_vendas,
	lista_cliente.nome, lista_cliente.apelido
	FROM
	(
			SELECT c.id_cliente, 
			pf.nome_pessoa_fisica nome, c.apelido_cliente apelido
			FROM cliente c 
			  INNER JOIN cliente_tipo_pessoa ctp 
			  	ON c.id_cliente_tipo_pessoa = ctp.id_cliente_tipo_pessoa
			  INNER JOIN tipo_pessoa tp 
			  	ON ctp.id_tipo_pessoa = tp.id_tipo_pessoa
			  	and tp.nome_tipo_pessoa = 'PF'
			   INNER JOIN pessoa_fisica pf 
			  	ON ctp.id_cliente_tipo_pessoa  = pf.id_cliente_tipo_pessoa	 	
			UNION ALL
			SELECT c.id_cliente, 
			pj.nome_pessoa_juridica nome, c.apelido_cliente apelido
			FROM cliente c 
			  INNER JOIN cliente_tipo_pessoa ctp 
			  	ON c.id_cliente_tipo_pessoa = ctp.id_cliente_tipo_pessoa
			  INNER JOIN tipo_pessoa tp 
			  	ON ctp.id_tipo_pessoa = tp.id_tipo_pessoa
			  	and tp.nome_tipo_pessoa = 'PJ'
			   INNER JOIN pessoa_juridica pj 
			  	ON ctp.id_cliente_tipo_pessoa  = pj.id_cliente_tipo_pessoa	
		) as lista_cliente 
		  INNER JOIN venda v
		  	ON lista_cliente.id_cliente = v.id_vendedor
		  	and YEAR(v.data) =  2020
		  INNER JOIN estoque e
		  	on v.id_produto = e.id_produto
		  INNER JOIN produto p
		  	on v.id_produto = p.id_produto
		  INNER JOIN categoria c
		  	on p.id_categoria = c.id_categoria
		  	and c.nome_categoria = 'Celulares'
		group by MONTH(v.data), YEAR(v.data),
		lista_cliente.nome, lista_cliente.apelido
)
,
ranking_vendas_por_vendedor_mes_2020 as
(
	SELECT vpcm.mes_venda, vpcm.ano_venda,vpcm.qtde_vendas, vpcm.qtde_produtos,
	vpcm.total_vendas,
	vpcm.nome, vpcm.apelido,
	DENSE_RANK() OVER (
            PARTITION BY vpcm.mes_venda 
            ORDER BY vpcm.total_vendas DESC
        ) ranking
	FROM vendas_por_cliente_mes_2020 vpcm
)

SELECT 
rvpvm.mes_venda, rvpvm.ano_venda, 
rvpvm.nome, rvpvm.apelido, rvpvm.qtde_vendas,
rvpvm.qtde_produtos, rvpvm.total_vendas
FROM ranking_vendas_por_vendedor_mes_2020 rvpvm
where rvpvm.ranking <= 5
order by rvpvm.ranking;

-- 3. Procedure para controlar o histórico do status dos produtos. 
-- A procedure deve receber como parâmetro uma data. Caso a data seja nula, 
-- a procedure deve considerar a data atual. A procedure deve excluir os registros do histórico de 
-- produtos para a data informada (conforme lógica explicada) e inserir novamente os dados, 
-- garantindo assim a unicidade dos dados para o mesmo dia.

CREATE PROCEDURE `ecommerce-challenge-ml`.proc_controle_historico_produto(data_parametro date)
BEGIN
	DECLARE data_reprocessamento date;
	DECLARE qtde_registro INT;
	DECLARE parametro_data_query date;
	
	DECLARE exit handler FOR SQLEXCEPTION
	BEGIN
	  GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, 
	   @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;
	  SET @full_error = CONCAT("ERROR ", @errno, " (", @sqlstate, "): ", @text);
	  SELECT @full_error;		
	END;
	
	SET data_reprocessamento = IFNULL(data_parametro, '1900-01-01');

	IF (data_reprocessamento <> '1900-01-01') THEN
		SET parametro_data_query = data_reprocessamento;
	END IF;
	
	SELECT COUNT(*)
 	INTO qtde_registro
	FROM historico_produto
	WHERE date(data) = date(current_time());
	
	IF (qtde_registro > 0) THEN
		SET parametro_data_query = date(current_time());
	END IF;	
	
	DELETE FROM historico_produto WHERE date(data) = parametro_data_query;
	
	INSERT INTO historico_produto
	(id_produto, status, preco, id_categoria)
	SELECT p.id_produto, p.status_produto, 0.00 preco, p.id_categoria
	FROM produto p;		
END;