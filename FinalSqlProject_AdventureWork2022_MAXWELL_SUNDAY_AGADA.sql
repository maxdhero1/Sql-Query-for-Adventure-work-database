--Activating database AdventureWorks2022
USE AdventureWorks2022

--displaying the HumanResources.Employee and Person.Person tables
SELECT * FROM person.Person
SELECT * FROM HumanResources.Employee
--TASK 1:List All Employees and Their Job Titles
--Join these tables to get the employees' first and last names along with their job titles.

SELECT
	pp.FirstName,
	pp.LastName,
	HRE.JobTitle
FROM 
	Person.Person pp
join HumanResources.Employee HRE
	ON pp.BusinessEntityID = HRE.BusinessEntityID

--TASK 2:Display All Products and Their List Prices
	--Query the Production.Product table to list all products with their respective list prices.

SELECT 
	Name AS ProductName,
	ListPrice AS ProductPrice
FROM 
	Production.Product

--TASK 3: Retrieve Customers Who Placed Orders in 2021
--Use the Sales.SalesOrderHeader, Sales.Customer, and Person.Person tables.
--Filter orders placed in the year 2021.

SELECT DISTINCT 
	COUNT(soh.SalesOrderID) AS Ordercount,
	c.CustomerID,
	pp.FirstName,
	pp.LastName
FROM 
	Sales.SalesOrderHeader soh
	JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	JOIN Person.Person pp ON c.PersonID = pp.BusinessEntityID
WHERE 
	YEAR(soh.OrderDate) = 2021
GROUP BY
	c.CustomerID,
	pp.FirstName,
	pp.LastName
ORDER BY 
	Ordercount DESC,
	c.CustomerID

--TASK 4:List the Top 10 Most Expensive Products 
--Query the Production.Product table.
--Sort the products by ListPrice in descending order and limit the results to the top 10.

SELECT
	TOP 10
	Name AS ProductName,
	ProductID,
	ListPrice,
	COUNT(ProductID) AS CountOfProduct
FROM Production.Product
GROUP BY
	Name,
	ProductID,
	ListPrice
ORDER BY
	ListPrice DESC,
	CountOfProduct

--Task 5: Show the Total Number of Orders Placed in 2021 
--Use the Sales.SalesOrderHeader table.
--Count the number of orders where the OrderDate falls in 2021.

SELECT COUNT(SalesOrderID) CountOfOrder
FROM 
	Sales.SalesOrderHeader
WHERE 
	YEAR(OrderDate) = 2021;

--Task 6: List Sales Orders with TotalDue Greater Than $1,500
--Objective: Highlight high-value transactions.
--Instructions: Query the Sales.SalesOrderHeader table.
--Filter orders where TotalDue exceeds $1,500.

SELECT 
	TotalDue,
	CustomerID,
	OrderDate,
	SalesOrderID
FROM 
	Sales.SalesOrderHeader
WHERE 
	TotalDue > 1500
ORDER BY
	TotalDue DESC
--Task 7: Retrieve Products with ListPrice Between $100 and $500
--Objective: Filter products within a specific price range.
--Instructions:Use the Production.Product table.
--Apply a WHERE clause to select products priced between $100 and $500.
SELECT 
	ProductID,
	Name AS ProductName,
	ListPrice
FROM 
	Production.Product
WHERE
	ListPrice BETWEEN 100 AND 500
ORDER BY
	ListPrice ASC

--Task 8: Retrieve Customers from a Specific Region (e.g., "United States")
--Objective: Segment customers based on geographical location.
--Instructions:Utilize the Sales.Customer, Person.Person, and Person.Address tables.
--Filter customers where CountryRegionName is "United States".
SELECT 
	pp.LastName,
	pp.FirstName,
	pcr.Name AS CountryRegionName,
	c.CustomerID,
	pa.City
FROM 
	Sales.Customer c
	INNER JOIN person.person pp ON c.CustomerID = pp.BusinessEntityID
	INNER JOIN person.BusinessEntityAddress pbe ON pp.BusinessEntityID = pbe.BusinessEntityID
	INNER JOIN person.Address pa ON pbe.AddressID = pa.AddressID
	INNER JOIN person.StateProvince psp ON pa.StateProvinceID = psp.StateProvinceID
	INNER JOIN Person.CountryRegion pcr ON psp.CountryRegionCode = pcr.CountryRegionCode
WHERE 
	pcr.Name = 'United States'
ORDER BY
	c.CustomerID DESC;

--Task 9: Calculate Total Sales Amount for Each Year from 2020 to 2022
--Objective: Analyze sales trends over multiple years.
--Instructions:Use the Sales.SalesOrderHeader table.
--Group sales by year and sum the TotalDue for each year between 2020 and 2022.
SELECT
	YEAR(OrderDate)AS SalesYear,
	SUM(TotalDue) AS TotalAmountSold
FROM
	Sales.SalesOrderHeader
WHERE 
	YEAR(OrderDate) BETWEEN 2020 AND 2022
GROUP BY
	YEAR(OrderDate)
ORDER BY
	 SalesYear ASC
--Task 10: Display Number of Orders Placed by Each Customer
--Objective: Understand customer ordering behavior.
--Instructions:Join Sales.SalesOrderHeader, Sales.Customer, and Person.Person tables.
--Group by CustomerID and count the number of orders per customer.
SELECT DISTINCT
	COUNT(soh.SalesOrderID) AS CountOfOrders,
	c.CustomerID,
	pp.FirstName,
	pp.LastName
FROM Sales.SalesOrderHeader soh
	JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	JOIN Person.Person pp ON c.CustomerID = pp.BusinessEntityID
GROUP BY
	c.CustomerID,
	pp.FirstName,
	pp.LastName
ORDER BY
	c.CustomerID 
--Task 11: List Products That Have Never Been Sold
--Objective: Identify unsold inventory.
--Instructions:Use the Production.Product and Sales.SalesOrderDetail tables.
--Find products in Production.Product that do not have corresponding entries in SalesOrderDetail.

SELECT 
	p.ProductID,
	P.Name AS ProductName,
	p.ListPrice,
	p.ProductNumber
FROM 
	production.Product p
	LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
	WHERE sod.ProductID IS NULL
ORDER BY
	p.ProductID DESC

--Task 12: Find Total Number of Employees with the Title "Sales Representative"
--Objective: Assess the size of the sales team.
--Instructions:Query the HumanResources.Employee table.
--Count employees where JobTitle is "Sales Representative".

SELECT
	COUNT(*) AS SalesTeamSize
FROM 
	HumanResources.Employee
WHERE 
	JobTitle = 'Sales Representative'

--Task 13: Retrieve Average ListPrice for All Products in the "Bikes" Category
--Objective: Determine pricing strategy for the Bikes category.
--Instructions:
--Join Production.Product, Production.ProductSubcategory, and Production.ProductCategory tables.
--Filter products belonging to the "Bikes" category and calculate the average ListPrice.

SELECT
	AVG(p.ListPrice) AS AvgPriceOfBike
FROM 
	production.Product p
	INNER JOIN Production.ProductSubcategory psc ON P.ProductSubcategoryID =psc.ProductSubcategoryID
	INNER JOIN Production.Productcategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE 
	pc.Name = 'Bikes'

--Task 14: List Top 5 Customers Based on Total Order Amount
--Objective: Identify top-performing customers.
--Instructions:Join Sales.SalesOrderHeader, Sales.Customer, and Person.Person tables.
--Sum TotalDue per customer and select the top 5 customers with the highest total order amounts.

SELECT TOP 5
	SUM(soh.TotalDue) AS TotalAmountOrdered,
	pp.FirstName,
	pp.LastName,
	c.CustomerID
FROM Sales.SalesOrderHeader soh
	JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	JOIN person.person pp ON c.PersonID = pp.BusinessEntityID
GROUP BY
	c.CustomerID,
	pp.FirstName,
	pp.LastName
ORDER BY
	TotalAmountOrdered DESC

--Task 15: Display All Products Sold More Than 50 Times in 2023
--Objective: Highlight high-demand products.
--Instructions:Join Production.Product and Sales.SalesOrderDetail tables.
--Filter sales from 2023 and group by ProductID to count sales exceeding 50.

SELECT 
	COUNT(sod.SalesOrderID) AS CountOfSales,
	P.Name AS ProductName,
	p.ProductID,
	soh.OrderDate,
	p.ListPrice
FROM Production.Product p
	JOIN Sales.SalesOrderDetail sod ON P.ProductID = sod.ProductID
	JOIN sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE
	YEAR(soh.OrderDate) = 2013
GROUP BY
	P.ProductID,
	p.Name,
	soh.OrderDate,
	p.ListPrice
HAVING
	COUNT(sod.SalesOrderID) > 50
ORDER BY
	CountOfSales DESC


SELECT *
FROM sales.SalesOrderHeader
SELECT *
FROM Production.Product