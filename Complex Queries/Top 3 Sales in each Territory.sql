SELECT * 
FROM Sales.SalesOrderHeader

SELECT *
FROM Sales.SalesPerson

SELECT * 
FROM HumanResources.Employee

SELECT * 
FROM Person.Person

SELECT * 
FROM Sales.SalesTerritory

CREATE VIEW PersonName AS
SELECT BusinessEntityID,CONCAT_WS(' ', FirstName, LastName) AS FULLNAME
FROM Person.Person

CREATE VIEW TerritySales AS
SELECT SalesPersonID, Name AS TerritoryName, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader AS A join Sales.SalesTerritory AS B ON A.TerritoryID = B.TerritoryID
GROUP BY A.SalesPersonID, A.TerritoryID, Name
HAVING A.SalesPersonID IS NOT NULL;


WITH RankedSales AS (
SELECT A.FULLNAME, B.TerritoryName, B.TotalSales, RANK() OVER (PARTITION BY TerritoryName ORDER BY TotalSales DESC) AS RankInTerritory 
FROM PersonName AS A JOIN TerritySales AS B on A.BusinessEntityID = B.SalesPersonID
) 
SELECT * 
FROM RankedSales
WHERE RankInTerritory < 4;


