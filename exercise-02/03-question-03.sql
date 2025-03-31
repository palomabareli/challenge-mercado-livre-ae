-- 3. Procedure para controlar o histórico do status dos produtos. 
-- A procedure deve receber como parâmetro uma data. Caso a data seja nula, 
-- a procedure deve considerar a data atual. A procedure deve excluir os registros do histórico de 
-- produtos para a data informada (conforme lógica explicada) e inserir novamente os dados, 
-- garantindo assim a unicidade dos dados para o mesmo dia.

USE `ecommerce-challenge-ml`;

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