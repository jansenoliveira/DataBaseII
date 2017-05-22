/*Questao 1*/
DECLARE a CURSOR
LOCAL
FOR
	SELECT
		AdventureWorks.HumanResources.Department.DepartmentID,
		AdventureWorks.HumanResources.Department.Name,
		COUNT(AdventureWorks.HumanResources.EmployeeDepartmentHistory.EmployeeID) as 'Total Funcionários'
	FROM
		AdventureWorks.HumanResources.Department
	INNER JOIN
		AdventureWorks.HumanResources.EmployeeDepartmentHistory
	ON
		AdventureWorks.HumanResources.Department.DepartmentID = AdventureWorks.HumanResources.EmployeeDepartmentHistory.EmployeeID 
	GROUP BY
		AdventureWorks.HumanResources.Department.DepartmentID,
		AdventureWorks.HumanResources.Department.Name

DECLARE @dp_id smallint, @dp_nome char(20), @tt_func int
OPEN a
FETCH a
	INTO @dp_id, @dp_nome, @tt_func
	PRINT RTRIM(@dp_id)
	PRINT RTRIM(@dp_nome)
	PRINT RTRIM(@tt_func)
CLOSE a
DEALLOCATE a


/*Questao 2*/
ALTER TABLE Production.Product add QtdVendor int

DECLARE b CURSOR
	global 
	keyset
	FOR
		SELECT  pv.ProductID, p.Name, count(pv.VendorID) as totalVend 
		FROM Production.Product as p
			INNER JOIN Purchasing.ProductVendor as pv on p.ProductID = pv.ProductID
		GROUP BY pv.ProductID, p.Name
	FOR UPDATE of QtdVendor

	declare @idProd int
	declare @Name nvarchar(50)
	declare @totvend int


	OPEN b
	FETCH FROM b into @idProd, @Name, @totvend

		WHILE @@FETCH_STATUS = 0
			BEGIN 
				UPDATE Production.Product SET QtdVendor = @totvend
				WHERE Production.Product.ProductID = @idProd
				fetch next FROM b into @idProd, @Name, @totvend
			END

CLOSE b
DEALLOCATE b


/*Questão 3*/
CREATE FUNCTION SalesMonthTop5 (@month int, @year int)
RETURNS TABLE
RETURN(
	SELECT TOP 5
		AdventureWorks.Sales.SalesOrderDetail.ProductID,
		AdventureWorks.Production.Product.Name,
		MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate) as 'Mes',
		YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate) as 'Ano',
		SUM(AdventureWorks.Sales.SalesOrderDetail.OrderQty) as 'Quantidade Total Vendida',
		AVG(AdventureWorks.Sales.SalesOrderDetail.UnitPrice) as 'Preco Unitario Médio',
		SUM(AdventureWorks.Sales.SalesOrderDetail.UnitPriceDiscount) as 'Desconto Total',
		SUM(AdventureWorks.Sales.SalesOrderDetail.LineTotal) as 'Valor Total Vendido'
	FROM
		AdventureWorks.Sales.SalesOrderDetail
	INNER JOIN
		AdventureWorks.Sales.SalesOrderHeader
	ON
		AdventureWorks.Sales.SalesOrderHeader.SalesOrderID = AdventureWorks.Sales.SalesOrderDetail.SalesOrderID
	INNER JOIN
		AdventureWorks.Production.Product
	ON
		AdventureWorks.Production.Product.ProductID = AdventureWorks.Sales.SalesOrderDetail.ProductID 
	WHERE 
		MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate) = @month
			AND
		YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate) = @year
	GROUP BY
			AdventureWorks.Production.Product.Name,
			AdventureWorks.Sales.SalesOrderDetail.ProductID,
			MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate),
			YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate)
	ORDER BY
		[Quantidade Total Vendida] DESC
)

SELECT * FROM SalesMonthTop5(10,2003)


/*Questao 4*/
CREATE FUNCTION SalesTop5 (@datInic datetime , @datFin datetime)
returns @t table(
	ProductId int,
	Name nvarchar(50),
	Mes int,
	Ano int,
	Posicao int,
	QtdTotVend int,
	PrecUnitMed float,
	DescTotConsed float,
	ValTotVend float
)
AS BEGIN	
	while @datInic <= @datFin
	BEGIN

		DECLARE c CURSOR
		read_only
		FOR
			SELECT	top 5 
				p.ProductID,
				p.Name,
				month(soh.OrderDate) as Mes,
				year(soh.OrderDate) as Ano,  
				sum(sod.OrderQty) as QtdVendida,
				avg(sod.UnitPrice) as MediaPrecoUnit,
				sum(sod.OrderQty*sod.UnitPriceDiscount) as TotDescCon,
				sum(sod.OrderQty * sod.UnitPrice) as ValorTotalVendido     
			FROM	
				Production.Product as p 
				inner join 
				Sales.SalesOrderDetail as sod on p.ProductID =  sod.ProductID
				inner join Sales.SalesOrderHeader as soh on soh.SalesOrderID = sod.SalesOrderID
			WHERE
				month(soh.OrderDate) = month(@datInic)
				and 
				year(soh.OrderDate) = year(@datInic)
			GROUP BY 
				p.ProductID,
				p.Name,
				month(soh.OrderDate),
				year(soh.OrderDate)
			ORDER BY
				sum(sod.OrderQty) desc 
				

		DECLARE 
			@ProductId int,
			@Names nvarchar(50),
			@Mes int,
			@Ano int,
			@QtdTotVend int,
			@PrecUnitMed float,
			@DescTotConsed float,
			@ValTotVend float
		
		open c
		
		fetch FROM c into @ProductId,
							@Names,
							@Mes,
							@Ano,
							@QtdTotVend,
							@PrecUnitMed,
							@DescTotConsed,
							@ValTotVend
		
		DECLARE @pos int = 1

		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO (ProductId,
							Name,
							Mes,
							Ano,
							Posicao,
							QtdTotVend,
							PrecUnitMed,
							DescTotConsed,
							ValTotVend) VALUES( @ProductId,
												@Names,
												@Mes,
												@Ano,
												@pos,
												@QtdTotVend,
												@PrecUnitMed,
												@DescTotConsed,
												@ValTotVend) 
			
			fetch next FROM c into @ProductId,
									@Names,
									@Mes,
									@Ano,
									@QtdTotVend,
									@PrecUnitMed,
									@DescTotConsed,
									@ValTotVend
			
			SET @pos = @pos+1
		END

		close c
		deallocate c

		SET @datInic = dateadd(month, 1, @datInic)
		
	END 
RETURN
END