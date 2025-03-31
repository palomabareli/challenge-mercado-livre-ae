-- 2. Liste os 5 vendedores que mais venderam em cada mês de 2020, 
-- considerando o total vendido por mês para a categoria 'Celulares'.

USE `ecommerce-challenge-ml`;

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
order by rvpvm.ranking