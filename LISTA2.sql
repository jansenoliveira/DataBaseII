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
CREATE VIEW singleauthors
WITH SCHEMABINDING
AS
	SELECT authors.au_id, authors.au_fname, titleauthor.title_id, titles.title,authors.qty
	FROM dbo.authors
	INNER JOIN dbo.titleauthor
	ON dbo.authors.au_id = dbo.titleauthor.au_id
	INNER JOIN dbo.titles 
	ON dbo.titleauthor.title_id = dbo.titles.title_id
	WHERE dbo.authors.qty = 1
WITH CHECK OPTION

SELECT * FROM singleauthors;


/*Questao 4*/
UPDATE singleauthors
SET qty = qty + 1
WHERE au_id = '172-32-1176'
/*SQL Error [550] [S0001]: The attempted insert or update failed because
the target view either specifies WITH CHECK OPTION or spans a view that
specifies WITH CHECK OPTION and one or more rows resulting from the operation
did not qualify under the CHECK OPTION constraint.*/


/*Questao 5*/
UPDATE singleauthors
SET title = 'The bible of ' + title
WHERE au_id = '722-51-5454';
/*O update funcionou normalmente.*/


/*Questao 6*/
ALTER TABLE Pubs.dbo.authors DROP COLUMN qty
/*SQL Error [5074] [S0001]: The object 'singleauthors' is dependent on column 'qty'.*/


/*Questao 7*/
INSERT INTO singleauthors values ('172-32-1170',' Autor', 'PS3330', 'Livro teste', 1)
/*SQL Error [4405] [S0001]: View or function 'singleauthors' is not updatable
because the modification affects multiple base tables.*/


/*Questao 8*/
DELETE singleauthors where au_id = '172-32-1176'
/*SQL Error [4405] [S0001]: View or function 'singleauthors' is not updatable
because the modification affects multiple base tables.*/


/*Questao 9*/
UPDATE singleauthors SET au_fname = 'Black' WHERE au_id = '172-32-1176'
/*O comando funcionou normalmente*/


/*Questao 10*/
DROP VIEW singleauthors;

CREATE VIEW singleauthors
WITH SCHEMABINDING,ENCRYPTION
AS
	SELECT authors.au_id, authors.au_fname, titleauthor.title_id, titles.title,authors.qty
	FROM dbo.authors
	INNER JOIN dbo.titleauthor
	ON dbo.authors.au_id = dbo.titleauthor.au_id
	INNER JOIN dbo.titles 
	ON dbo.titleauthor.title_id = dbo.titles.title_id
	WHERE dbo.authors.qty = 1
WITH CHECK OPTION