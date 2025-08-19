SELECT BusinessEntityID
      ,SalesYTD
      ,(SELECT MAX(SalesYTD)
         FROM Sales.SalesPerson) AS MaximumSales
         ,(SELECT MAX(SalesYTD)
         FROM Sales.SalesPerson)  - SalesYTD As SalesGap
FROM Sales.SalesPerson
ORDER BY SalesGap DESC;



SELECT *
FROM Sales.SalesOrderDetail


SELECT SalesOrderID
      ,SUM(Linetotal) AS TotalPrice
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(LineTotal) > (SELECT AVG(ResultTable.TotalValue) AS AverageValue
                        FROM (SELECT SUM(LineTotal) AS TotalValue
                              FROM Sales.SalesOrderDetail
                              GROUP BY SalesOrderID) AS ResultTable)
ORDER BY TotalPrice DESC;

SELECT AVG(ResultTable.TotalValue) AS AverageValue
FROM (SELECT SUM(LineTotal) AS TotalValue
      FROM Sales.SalesOrderDetail
      GROUP BY SalesOrderID) AS ResultTable

-- Correlated SubQueries
SELECT BusinessEntityID
      ,FirstName
      ,LastName
      ,(SELECT JobTitle
           FROM HumanResources.Employee
           WHERE BusinessEntityID = Person.BusinessEntityID) AS JobTitle 
FROM Person.Person AS Person
WHERE (SELECT JobTitle --Also We can write Exists here
           FROM HumanResources.Employee
           WHERE BusinessEntityID = Person.BusinessEntityID) IS NOT NUll;