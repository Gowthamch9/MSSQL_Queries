--Count of Total Cities with respect to the State/Province
SELECT City, StateProvinceID, COUNT(*) AS 'Total Addresses'
FROM Person.Address
GROUP BY City, StateProvinceID
ORDER BY [Total Addresses] DESC;

SELECT * 
FROM Sales.SalesOrderDetail

--Highest Amount in a single Sales Order
SELECT SalesOrderID, Round(Sum(LineTotal),2) AS 'Total Sale Value', SUM(OrderQty) AS 'Number of Items', COUNT(DISTINCT ProductID) AS 'Distinct Items'
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY [Total Sale Value] DESC;

--Popular Items 
SELECT ProductID, SUM(OrderQty) AS 'Total Number of Quantity Sold'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY [Total Number of Quantity Sold] DESC;

--Having Clause
SELECT Color, Count(*) AS A
FROM Production.Product
WHERE Color IS NOT NULL
GROUP BY Color
HAVING Count(*) > 25;


--Challenge
SELECT * 
FROM Sales.SalesOrderHeader

SELECT * 
FROM Person.Person

SELECT B.CustomerID,
       A.FirstName, 
       A.LastName, 
       SUM(B.TotalDue) AS TotalPurchase, 
       MIN(B.TotalDue) AS MinimumSingleOrder, 
       Max(B.TotalDue) AS MaximumSingleOrder, 
       AVG(B.TotalDue) AS AverageOrdervalue
FROM Person.Person AS A 
     JOIN Sales.SalesOrderHeader AS B 
     ON B.CustomerID = A.BusinessEntityID
GROUP BY B.CustomerID, A.FirstName, A.LastName
ORDER BY TotalPurchase DESC;