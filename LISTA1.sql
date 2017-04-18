	#1	
		SELECT Pubs.dbo.titles.title_id, Pubs.dbo.titles.title, Pubs.dbo.authors.au_fname
		FROM Pubs.dbo.titleauthor
		INNER JOIN Pubs.dbo.titles
		ON Pubs.dbo.titleauthor.title_id = Pubs.dbo.titles.title_id
		INNER JOIN Pubs.dbo.authors
		ON Pubs.dbo.titleauthor.au_id = Pubs.dbo.authors.au_id
		ORDER BY Pubs.dbo.titles.title ASC, Pubs.dbo.authors.au_fname ASC;

	#2
		SELECT Pubs.dbo.titles.title_id, Pubs.dbo.titles.title, 
		COUNT(Pubs.dbo.titleauthor.au_id)
		FROM Pubs.dbo.titleauthor
		INNER JOIN Pubs.dbo.titles
		ON Pubs.dbo.titleauthor.title_id = Pubs.dbo.titles.title_id
		GROUP BY Pubs.dbo.titles.title, Pubs.dbo.titles.title_id
		ORDER BY Pubs.dbo.titles.title ASC;	

	#3
		SELECT Pubs.dbo.publishers.pub_id, Pubs.dbo.publishers.pub_name
		FROM Pubs.dbo.titles 
		INNER JOIN Pubs.dbo.publishers 
		ON Pubs.dbo.titles.pub_id = Pubs.dbo.publishers.pub_id
		GROUP BY Pubs.dbo.publishers.pub_id, Pubs.dbo.publishers.pub_name HAVING count(Pubs.dbo.titles.pub_id) > 5

	#4
		CREATE PROCEDURE Inserir_Loja;1
			@id INT,
			@name VARCHAR,
			@address VARCHAR,
			@city VARCHAR,
			@state VARCHAR,
			@zip VARCHAR
		
			AS
		
			INSERT INTO Pubs.dbo.stores
			(Pubs.dbo.stores.stor_id, Pubs.dbo.stores.stor_name, 
			Pubs.dbo.stores.stor_address, Pubs.dbo.stores.city, 
			Pubs.dbo.stores.state, Pubs.dbo.stores.zip)
			VALUES 
			(@id, @name, @address, @city, @state, @zip)

	#5
		CREATE PROCEDURE Apagar_loja;1
	
			AS
	
			DELETE FROM Pubs.dbo.stores
			WHERE (Pubs.dbo.stores.stor_id 
			NOT IN (SELECT Pubs.dbo.sales.stor_id from Pubs.dbo.sales))		

	#6
		SELECT  Pubs.dbo.publishers.pub_name,Pubs.dbo.titles.title, Pubs.dbo.authors.au_fname
		FROM Pubs.dbo.titles
		INNER JOIN Pubs.dbo.titleauthor
		ON Pubs.dbo.titleauthor.title_id = Pubs.dbo.titles.title_id
		INNER JOIN Pubs.dbo.publishers
		ON Pubs.dbo.publishers.pub_id = Pubs.dbo.titles.pub_id
		INNER JOIN Pubs.dbo.authors
		ON Pubs.dbo.titleauthor.au_id = Pubs.dbo.authors.au_id
		WHERE Pubs.dbo.titles.pub_id
		IN
		(
			SELECT a.pub_id
			FROM (
				SELECT TOP 1 titles.pub_id,count(titles.pub_id) as 'total'
				FROM titles
				INNER JOIN publishers
				ON titles.pub_id = publishers.pub_id
				GROUP BY  titles.pub_id
				ORDER BY 'total' DESC
				) as a
		)

	#7	
		SELECT Pubs.dbo.titles.title FROM Pubs.dbo.titleauthor 
		INNER JOIN Pubs.dbo.titles 
		ON Pubs.dbo.titleauthor.title_id = Pubs.dbo.titles.title_id  
		WHERE Pubs.dbo.titleauthor.au_id IN
		(
			SELECT a.au_id FROM 
			(
				SELECT TOP 1 Pubs.dbo.titleauthor.au_id, AVG(Pubs.dbo.titles.price) as 'media' FROM Pubs.dbo.titles
				INNER JOIN Pubs.dbo.titleauthor 
				ON Pubs.dbo.titleauthor.title_id = Pubs.dbo.titles.title_id  
				INNER JOIN Pubs.dbo.authors
				ON Pubs.dbo.titleauthor.au_id = Pubs.dbo.authors.au_id 
				GROUP BY Pubs.dbo.titleauthor.au_id
				ORDER BY 'media' DESC
			) as a
		)
	#8
		SELECT Pubs.dbo.titles.title FROM Pubs.dbo.titles
		WHERE Pubs.dbo.titles.title_id IN 
		(
			SELECT a.title_id 
			FROM
			(
				SELECT Pubs.dbo.titles.title_id, SUM(Pubs.dbo.roysched.royalty) as 'total' FROM Pubs.dbo.titles
				INNER JOIN Pubs.dbo.roysched 
				ON Pubs.dbo.roysched.title_id = Pubs.dbo.titles.title_id
				GROUP BY Pubs.dbo.titles.title_id HAVING SUM(Pubs.dbo.roysched.royalty) <> 100
			) as a 
		)

	9#	
		CREATE PROCEDURE listar_autor_sem_pub;1
			AS
			SELECT Pubs.dbo.authors.au_fname, Pubs.dbo.authors.phone FROM Pubs.dbo.authors
			LEFT JOIN Pubs.dbo.titleauthor
			ON Pubs.dbo.authors.au_id = Pubs.dbo.titleauthor.au_id
			WHERE Pubs.dbo.titleauthor.title_id is NULL

	#10
		CREATE PROCEDURE Valor_total;1
			@livro_id varchar(6)

			AS

			SELECT SUM(qty) from Pubs.dbo.sales
			INNER JOIN Pubs.dbo.titles
			ON Pubs.dbo.sales.title_id = Pubs.dbo.titles.title_id
			GROUP BY Pubs.dbo.sales.title_id HAVING @livro_id = Pubs.dbo.sales.title_id

	#11
		CREATE PROCEDURE total_royalties_autor;1
			@autor_id VARCHAR(11)

			AS

			SELECT SUM(Pubs.dbo.titles.royalty) FROM Pubs.dbo.titleauthor 
			INNER JOIN Pubs.dbo.titles ON Pubs.dbo.titles.title_id = Pubs.dbo.titleauthor.title_id 
			GROUP by Pubs.dbo.titleauthor.au_id HAVING Pubs.dbo.titleauthor.au_id = @autor_id
	#12		
			CREATE PROCEDURE total_royalties_pub;1
				@pub_id CHAR(4)

				AS
				
				SELECT SUM(Pubs.dbo.titles.royalty) FROM Pubs.dbo.titleauthor 
				INNER JOIN Pubs.dbo.titles ON Pubs.dbo.titles.title_id = Pubs.dbo.titleauthor.title_id
				INNER JOIN Pubs.dbo.publishers ON Pubs.dbo.titles.pub_id = Pubs.dbo.publishers.pub_id  
				GROUP by Pubs.dbo.publishers.pub_id HAVING Pubs.dbo.publishers.pub_id = @pub_id

