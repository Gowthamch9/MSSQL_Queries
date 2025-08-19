/* 
Challenge: "Dead Stock and Slow-Moving Products Report"

Scenario: The inventory team at AdventureWorks wants to reduce warehouse clutter by identifying products that are either:

Never sold at all (dead stock), or

Sold very infrequently (slow movers)

They want a detailed report to help make decisions on discontinuing or discounting products.
*/


SELECT *
FROM Production.Product

SELECT *
FROM Production.ProductSubcategory

SELECT *
FROM Production.ProductCategory

SELECT *
FROM Sales.SalesOrderDetail

SELECT MAX(OrderDate)
FROM Sales.SalesOrderHeader

--VIEWS
CREATE VIEW ProducttSubcategory1 AS(
SELECT P.ProductID
      ,P.Name AS ProductName
      ,PS.ProductCategoryID
      ,PS.Name AS ProductSubCategoryName
FROM Production.Product AS P JOIN Production.ProductSubcategory AS PS on P.ProductSubcategoryID = PS.ProductSubcategoryID)

CREATE VIEW ProductCategory AS(
SELECT PSC.ProductID
      ,PSC.ProductName 
      ,PC.Name as ProductCatergoryName
FROM ProducttSubcategory1 AS PSC join Production.ProductCategory AS PC ON PC.ProductCategoryID = PSC.ProductCategoryID)

CREATE VIEW SalesAgreg AS (
SELECT SalesOrderID
      ,ProductID
      ,SUM(OrderQTY) AS TotalQTY
      ,SUM(LineTotal) AS TotalPrice
FROM Sales.SalesOrderDetail
GROUP BY ProductID,SalesOrderID)

CREATE VIEW SalesDetails AS (
SELECT SA.ProductID
      ,COUNT(DISTINCT SA.SalesOrderID)
      ,SUM(SA.TotalQTY) AS TotalQuantitySold
      ,SUM(SA.TotalPrice) AS TotalPrice
      ,DATEDIFF(Day,MAX(SOH.OrderDate), '2015-01-01') AS DaySinceLastOrdered
FROM SalesAgreg AS SA JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SA.SalesOrderID
GROUP BY SA.ProductID)

CREATE VIEW ProductSales AS (
SELECT PC.ProductID
      ,PC.ProductName
      ,PC.ProductCatergoryName
      ,SD.TotalQuantitySold
      ,SD.TotalPrice
      ,SD.DaySinceLastOrdered
FROM ProductCategory AS PC LEFT JOIN SalesDetails AS SD ON PC.ProductID = SD.ProductID)

SELECT *
FROM ProductSales
--------------------------------------------------------------------------------------------------------------------


;WITH ProducttSubcategory1 AS(
SELECT P.ProductID
      ,P.Name AS ProductName
      ,PS.ProductCategoryID
      ,PS.Name AS ProductSubCategoryName
FROM Production.Product AS P JOIN Production.ProductSubcategory AS PS on P.ProductSubcategoryID = PS.ProductSubcategoryID),

ProductCategory AS(
SELECT PSC.ProductID
      ,PSC.ProductName 
      ,PC.Name as ProductCatergoryName
FROM ProducttSubcategory1 AS PSC join Production.ProductCategory AS PC ON PC.ProductCategoryID = PSC.ProductCategoryID),

SalesAgg AS (
SELECT SalesOrderID
      ,ProductID
      ,SUM(OrderQTY) AS TotalQTY
      ,SUM(LineTotal) AS TotalPrice
FROM Sales.SalesOrderDetail
GROUP BY ProductID,SalesOrderID),

SalesDetails AS (
SELECT SA.ProductID
      ,SUM(SA.TotalQTY) AS TotalQuantitySold
      ,SUM(SA.TotalPrice) AS TotalPrice
      ,DATEDIFF(Day,MAX(SOH.OrderDate), '2015-01-01') AS DaySinceLastOrdered
FROM SalesAgg AS SA JOIN Sales.SalesOrderHeader AS SOH ON SOH.SalesOrderID = SA.SalesOrderID
GROUP BY SA.ProductID),

ProductSales AS (
SELECT PC.ProductID
      ,PC.ProductName
      ,PC.ProductCatergoryName
      ,SD.TotalQuantitySold
      ,SD.TotalPrice
      ,SD.DaySinceLastOrdered
FROM ProductCategory AS PC LEFT JOIN SalesDetails AS SD ON PC.ProductID = SD.ProductID)

SELECT *
      ,CASE 
           WHEN TotalQuantitySold IS NULL AND TotalPrice IS NULL AND DaySinceLastOrdered IS NULL THEN 'Dead Stock'
           WHEN DaySinceLastOrdered > 365 AND TotalQuantitySold < 10 THEN 'Slow Moving'
           ELSE 'ACTIVE'
           END AS STATUS
FROM ProductSales
ORDER BY COALESCE(TotalPrice,0) DESC;


