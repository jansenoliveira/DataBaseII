/*Questao 1*/

/*Questao 2*/

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
CREATE FUNCTION Top5(@CurrentDate DATETIME)
RETURNS TABLE
RETURN (
	SELECT TOP 5
	    AdventureWorks.Sales.SalesOrderDetail.ProductID,
	    AdventureWorks.Production.Product.Name,
	    MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate) as 'Month',
	    YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate) as 'Year',
	    SUM(AdventureWorks.Sales.SalesOrderDetail.OrderQty) as 'Total Quantity Sold',
	    AVG(AdventureWorks.Sales.SalesOrderDetail.UnitPrice) as 'Average Unit Price',
	    SUM(AdventureWorks.Sales.SalesOrderDetail.UnitPriceDiscount) as 'Total Discount',
	    SUM(AdventureWorks.Sales.SalesOrderDetail.LineTotal) as 'Total Value Sold'
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
	    MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate) = MONTH(@CurrentDate)
	    and
	    YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate) = YEAR(@CurrentDate)
	GROUP BY
	        AdventureWorks.Production.Product.Name,
	        AdventureWorks.Sales.SalesOrderDetail.ProductID,
	        MONTH(AdventureWorks.Sales.SalesOrderHeader.OrderDate),
	        YEAR(AdventureWorks.Sales.SalesOrderHeader.OrderDate)
	ORDER BY
	    [Total Quantity Sold] DESC
)


/*Apenas Para Testar*/
DECLARE @CurrentDate DATETIME = '2001-10-10'
DECLARE @EndDate DATETIME = '2002-10-10'

WHILE @CurrentDate < @EndDate
BEGIN
	PRINT @CurrentDate
	SET @CurrentDate = DATEADD(MONTH, 1, @CurrentDate); 
END 