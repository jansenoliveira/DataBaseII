/*Questao 1*/
CREATE FUNCTION SalesMonth (@month int, @year int)
RETURNS TABLE
AS
RETURN (
	SELECT
		AdventureWorks.Sales.SalesOrderDetail.ProductID,
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
	WHERE 
		MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate) = @month
			AND
		YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate) = @year
	GROUP BY
			AdventureWorks.Sales.SalesOrderDetail.ProductID,
			MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate),
			YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate)
)

SELECT * FROM SalesMonth(10,2001)


/*Questao 3*/
CREATE FUNCTION CategorySalesMonth (@month int, @year int)
RETURNS TABLE
AS
RETURN (
	SELECT
		Production.ProductCategory.ProductCategoryID,
		MONTH(Sales.SalesOrderHeader.OrderDate) as 'Mes',
		YEAR(Sales.SalesOrderHeader.OrderDate) as 'Ano',
		SUM(Sales.SalesOrderDetail.OrderQty) as 'Quantidade Total Vendida',
		AVG(Sales.SalesOrderDetail.UnitPrice) as 'Preco Unitario Médio',
		SUM(Sales.SalesOrderDetail.UnitPriceDiscount) as 'Desconto Total',
		SUM(Sales.SalesOrderDetail.LineTotal) as 'Valor Total Vendido'
	FROM
		Sales.SalesOrderDetail
	INNER JOIN
		Sales.SalesOrderHeader
	ON
		Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
	INNER JOIN
		Production.Product
	ON
		Production.Product.ProductID = 	Sales.SalesOrderDetail.ProductID
	INNER JOIN
		Production.ProductSubcategory
	ON	
		Production.ProductSubcategory.ProductSubcategoryID = Production.Product.ProductSubcategoryID
	INNER JOIN 
		Production.ProductCategory
	ON
		Production.ProductCategory.ProductCategoryID = Production.ProductSubcategory.ProductCategoryID
	WHERE 
		MONTH(Sales.SalesOrderHeader.OrderDate) = @month
			AND
		YEAR(Sales.SalesOrderHeader.OrderDate) = @year
	GROUP BY
			Production.ProductCategory.ProductCategoryID,
			MONTH(Sales.SalesOrderHeader.OrderDate),
			YEAR(Sales.SalesOrderHeader.OrderDate)
)

SELECT * FROM CategorySalesMonth(10,2001)

/*Questao 4*/