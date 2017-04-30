/*Questao 1*/
ALTER TABLE Pubs.dbo.authors ADD qty INT, midprice FLOAT;


/*Questao 2*/
CREATE PROCEDURE calc_qty_midprice;1
AS
	UPDATE Pubs.dbo.authors
	SET Pubs.dbo.authors.qty = i.qty,
	Pubs.dbo.authors.midprice = i.midprice
	FROM (
		SELECT Pubs.dbo.titleauthor.au_id,count(Pubs.dbo.titleauthor.title_id) as 'qty', avg(price) as 'midprice'
		FROM Pubs.dbo.titleauthor
		INNER JOIN Pubs.dbo.titles
		ON Pubs.dbo.titleauthor.title_id = Pubs.dbo.titles.title_id
		GROUP BY au_id
	) i
	WHERE Pubs.dbo.authors.au_id = i.au_id


/*Questao 3*/
/*Gatilho para atualizar quando adicionar um novo autor no titleauthor*/
CREATE TRIGGER adicionar_author
ON Pubs.dbo.titleauthor
FOR INSERT
AS
	UPDATE Pubs.dbo.authors
	SET Pubs.dbo.authors.qty = Pubs.dbo.authors.qty + 1
	FROM Inserted
	WHERE Pubs.dbo.authors.au_id = Inserted.au_id
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Erro de Processamento',16,1)
		RETURN
	END

/*Gatilho para atualizar quando remover um autor no titleauthor*/
CREATE TRIGGER remover_author
ON Pubs.dbo.titleauthor
FOR DELETE
AS
	UPDATE Pubs.dbo.authors
	SET Pubs.dbo.authors.qty = Pubs.dbo.authors.qty - 1
	FROM Deleted
	WHERE Pubs.dbo.authors.au_id = Deleted.au_id
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Erro de Processamento',16,1)
		RETURN
	END


/*Questao 4*/
CREATE TRIGGER ajustar_preco
ON titles
AFTER UPDATE
AS
IF(UPDATE (price))
	EXEC calc_qty_midprice;1
	
	IF @@ERROR <> 0
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Erro de Processamento',16,1)
		RETURN
	END


/*Questao 5*/
/*Inserir autor de um livro*/
INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper) values ('213-46-8915', 'TC4203', 1, 100)
/*Deletar autor de um livro*/
DELETE FROM titleauthor WHERE au_id = '213-46-8915' AND title_id = 'TC4203';
/*Mudar o preco de um livro*/
UPDATE titles SET price = 5.99 WHERE title_id = 'BU2075'
/*As colunas qty e midprice atualizaram automaticamente de acordo com que cada comando de
INSERT, DELETE (na tabela titleauthor) ou UPDATE (na tabela titles) foi executado*/