-- 1. Quantos clientes nasceram no dia de hoje e realizaram mais de 1500 vendas em janeiro de 2020?
-- Partindo do pre-suposto de que empresas não fazem aniversário, considerando deste 
-- modo somente clientes do tipo pessoa física.

USE `ecommerce-challenge-ml`;

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