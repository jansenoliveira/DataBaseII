/*Questao 1*/
CREATE PROCEDURE questao1
		@lastName varchar(20), @firstName varchar(10), @territorio varchar(50), @regiao varchar(50)
	AS			
		declare @emp int		

		set @emp = 1		

		BEGIN TRANSACTION
				
			if not Exists(select * from Employees where rtrim(ltrim(FirstName)) like @firstName and rtrim(ltrim(LastName)) like @lastName)
				Insert Into Employees (LastName,FirstName) values (@lastName,@firstName)			

			if not Exists(select * from Employees where rtrim(ltrim(FirstName)) like @firstName and rtrim(ltrim(LastName)) like @lastName)
				set @emp = 0

			if not Exists(select * from Region where rtrim(ltrim(RegionDescription)) like @regiao)
				Insert Into Region(RegionDescription, RegionID) values (@regiao, (select max(RegionID) as total from Region) + 1)

			if not Exists(select * from Territories where rtrim(ltrim(TerritoryDescription)) like @territorio)
				Insert Into Territories(TerritoryDescription,RegionID, TerritoryID) values (@territorio, (select RegionID from Region where rtrim(ltrim(RegionDescription)) like @regiao), (select max(TerritoryID) from Territories) + 1)											

			if(@emp = 0)
				Insert Into EmployeeTerritories (EmployeeID,TerritoryID) values ( (select EmployeeID from Employees where rtrim(ltrim(FirstName)) like @firstName and rtrim(ltrim(LastName)) like @lastName) , 
				                                                                  (select TerritoryID from Territories where rtrim(ltrim(TerritoryDescription)) like @territorio) )
		IF @@ERROR <> 0
               BEGIN
                      ROLLBACK TRANSACTION
		      RAISERROR(50001, 16, 1, 'Deu erro na consulta')
                      RETURN
               END

		COMMIT TRANSACTION

/*Questao 2*/
CREATE FUNCTION VendaCategoriaMes (@month int, @year int)
RETURNS TABLE
AS
RETURN (
	SELECT
	NorthWind.dbo.Categories.CategoryID,
	NorthWind.dbo.Categories.CategoryName,
	SUM(NorthWind.dbo."Order Details".Quantity * NorthWind.dbo."Order Details".UnitPrice) as 'Total de Vendas dos Produtos Por Categoria'
FROM 
	NorthWind.dbo.Categories
INNER JOIN
	NorthWind.dbo.Products
ON
	NorthWind.dbo.Products.CategoryID = NorthWind.dbo.Categories.CategoryID
INNER JOIN
	NorthWind.dbo."Order Details"
ON
	NorthWind.dbo."Order Details".ProductID = NorthWind.dbo.Products.ProductID 
INNER JOIN
	NorthWind.dbo.Orders
ON
	NorthWind.dbo.Orders.OrderID = NorthWind.dbo."Order Details".OrderID
WHERE 
	MONTH(NorthWind.dbo.Orders.OrderDate) = @month AND YEAR(NorthWind.dbo.Orders.OrderDate) = @year
GROUP BY
	NorthWind.dbo.Categories.CategoryID,
	NorthWind.dbo.Categories.CategoryName
)

/*Questão 3*/
declare @table table(IDProduto int, NomeProduto varchar(50),IDCustomer nchar(5), NomeCustomer varchar(50),qty_adquirida int, Ano int)
declare @ID int
declare @Nome varchar(50)
declare @IDCustomer nchar(5)
declare @NomeCustomer varchar(50)
declare @qty_adquirida int
declare @Ano int=1996
declare cur cursor 
	for 
		select Products.ProductID,ProductName from Products 
			inner join "Order Details" on Products.ProductID = "Order Details".ProductID inner join 
  Orders on "Order Details".OrderID=orders.OrderID where  YEAR(OrderDate)=@Ano  group by products.ProductID, ProductName
  open cur
  fetch next from cur into @ID,@Nome
  while @@FETCH_STATUS=0
  begin 
  select top 1 @IDCustomer= Customers.CustomerID, @NomeCustomer = customers.CompanyName, @qty_adquirida = Sum([Order Details].Quantity) from [dbo].[Products] inner join
  [Order Details] on Products.ProductID=[Order Details].ProductID inner join 
  Orders on [Order Details].OrderID=orders.OrderID inner join 
  Customers on customers.CustomerID=Orders.CustomerID where YEAR(OrderDate)=@Ano 
  and Products.ProductID=@ID  group by customers.CustomerID, CompanyName order by Sum([Order Details].Quantity) desc
  
  insert into @table values(@ID,@Nome,@IDCustomer,@NomeCustomer,@qty_adquirida,@ano)

    fetch next from cur into @ID,@Nome
  end
  close cur
  deallocate cur
  select * from @table