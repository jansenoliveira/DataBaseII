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