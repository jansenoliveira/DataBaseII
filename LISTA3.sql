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
	WHERE Pubs.dbo.authors.au_id = au_id.au_id


/*Questao 3*/
