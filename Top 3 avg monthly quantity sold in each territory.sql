--Recursive Comman Table Expressions
WITH Numbers AS(
SELECT 1 as Num
UNION ALL
SELECT Num + 1
FROM Numbers
WHERE Num < 10)

---------------------------------------------------------------------------------------------------------------

/* Question - For each Sales Territory, identify the top 3 best-selling products based on total quantity sold.
For Each Product show:

Product Name
Territory Name
Total Quantity Sold
Total Sales
First and Last Date it was sold
Number of distinct customers who purchasd it
Trend indicator:
'Increasing' if average monthly sales qunatity increased over-time
'Decreasing' if it declined
'Stable' if there is no significant change

Tables: 
Sales.SalesOrderDetail
Sales.SalesOrderHeader
Sales.SalesTerritory
Production.Product */

----Tables Required for the Querying---------------------------------------------------------------------------

SELECT *
FROM Sales.SalesOrderHeader
-- SalesOrderID, OrderDate, TerritoryID, CustomerID

SELECT * 
FROM Sales.SalesOrderDetail
-- SalesOrderID, OrderQty, ProductID, LineTotal 

SELECT * 
FROM Sales.SalesTerritory
-- TerritoryID, Name

SELECT * 
FROM Production.Product
-- ProductID, Name

--Intermediate Views for analyzing the data quickly-------------------------------------------------------

CREATE VIEW TerritorySales AS (
SELECT SOH.SalesOrderId
      ,SOH.OrderDate
      ,SOH.TerritoryID
      ,SOH.CustomerID
      ,ST.Name AS TerritoryName
FROM Sales.SalesOrderHeader AS SOH join Sales.SalesTerritory AS ST ON SOH.TerritoryId = ST.TerritoryID)

CREATE VIEW ProductDetails AS (
SELECT SOD.SalesOrderID
      ,SOD.OrderQty
      ,SOD.ProductID
      ,SOD.LineTotal
      ,P.Name as ProductName
FROM Sales.SalesOrderDetail AS SOD join Production.Product AS P ON SOD.ProductID = P.ProductID)

CREATE VIEW SalesAggregation AS(
SELECT PD.ProductName
      ,TS.TerritoryName
      ,SUM(PD.OrderQty) AS TotalOrders
      ,SUM(PD.LineTotal) AS TotalSales
      ,COUNT(DISTINCT(TS.CustomerID)) AS UniqueCustomers
      ,MIN(TS.OrderDate) AS FirstDate
      ,MAX(TS.OrderDate) AS LastDate
FROM TerritorySales AS TS join ProductDetails AS PD ON TS.SalesOrderID = PD.SalesOrderID
GROUP BY PD.ProductName, TS.TerritoryName
ORDER BY TotalOrders DESC)

CREATE VIEW TopRank AS(
SELECT *
      ,RANK() OVER (PARTITION BY TerritoryName ORDER BY TotalOrders DESC) AS TerritoryRank
FROM SalesAggregation)

CREATE VIEW MonthlySales AS(
SELECT PD.ProductName
      ,TS.TerritoryName 
      ,YEAR(TS.OrderDate) AS Year
      ,MONTH(TS.OrderDate) AS Month
      ,SUM(PD.OrderQty) AS MonthlySales
FROM TerritorySales AS TS join ProductDetails AS PD ON TS.SalesOrderID = PD.SalesOrderID
GROUP BY PD.ProductName ,TS.TerritoryName ,YEAR(TS.OrderDate), MONTH(TS.OrderDate)
)

CREATE VIEW TrendCalc AS(
SELECT ProductName
      ,TerritoryName
      ,AVG(CASE WHEN Year < 2013 THEN MonthlySales END) AS AvgEarly
      ,AVG(CASE WHEN Year >= 2013 THEN MonthlySales END) AS AvgRecent
FROM MonthlySales
GROUP BY ProductName, TerritoryName)

---------------------------------------------------------------------------------------------------

--Solution for the Problem-----------------------------------------------------------------------------------
WITH TerritorySales AS(
SELECT SOH.SalesOrderId
      ,SOH.OrderDate
      ,SOH.TerritoryID
      ,SOH.CustomerID
      ,ST.Name AS TerritoryName
FROM Sales.SalesOrderHeader AS SOH join Sales.SalesTerritory AS ST ON SOH.TerritoryId = ST.TerritoryID),

ProductDetails AS(
SELECT SOD.SalesOrderID
      ,SOD.OrderQty
      ,SOD.ProductID
      ,SOD.LineTotal
      ,P.Name as ProductName
FROM Sales.SalesOrderDetail AS SOD join Production.Product AS P ON SOD.ProductID = P.ProductID),

SalesAggregation AS(
SELECT PD.ProductName
      ,TS.TerritoryName
      ,SUM(PD.OrderQty) AS TotalOrders
      ,SUM(PD.LineTotal) AS TotalSales
      ,COUNT(DISTINCT(TS.CustomerID)) AS UniqueCustomers
      ,MIN(TS.OrderDate) AS FirstDate
      ,MAX(TS.OrderDate) AS LastDate
FROM TerritorySales AS TS join ProductDetails AS PD ON TS.SalesOrderID = PD.SalesOrderID
GROUP BY PD.ProductName, TS.TerritoryName
),

TopRank AS(
SELECT *
      ,RANK() OVER (PARTITION BY TerritoryName ORDER BY TotalOrders DESC) AS TerritoryRank
FROM SalesAggregation),

MonthlySales AS(
SELECT PD.ProductName
      ,TS.TerritoryName 
      ,YEAR(TS.OrderDate) AS Year
      ,MONTH(TS.OrderDate) AS Month
      ,SUM(PD.OrderQty) AS MonthlySales
FROM TerritorySales AS TS join ProductDetails AS PD ON TS.SalesOrderID = PD.SalesOrderID
GROUP BY PD.ProductName ,TS.TerritoryName ,YEAR(TS.OrderDate), MONTH(TS.OrderDate)
),

TrendCalc AS(
SELECT ProductName
      ,TerritoryName
      ,AVG(CASE WHEN Year < 2013 THEN MonthlySales END) AS AvgEarly
      ,AVG(CASE WHEN Year >= 2013 THEN MonthlySales END) AS AvgRecent
FROM MonthlySales
WHERE Year BETWEEN 2010 AND 2014
GROUP BY ProductName, TerritoryName),


Final AS(
SELECT TP.ProductName
      ,TP.TerritoryName
      ,TP.TotalOrders
      ,CAST(TP.TotalSales  AS DECIMAL(10,2)) AS TotalSales
      ,TP.UniqueCustomers
      ,TP.FirstDate
      ,TP.LastDate
      ,TP.TerritoryRank
      ,CASE 
           WHEN TC.AvgEarly IS NULL AND TC.AvgRecent IS NULL THEN 'No Trend'
           WHEN TC.AvgRecent > TC.AvgEarly * 1.2 THEN 'Increasing'
           WHEN TC.AvgRecent < TC.AvgEarly * 0.8 THEN 'Decreasing'
           ELSE 'STABLE'
           END AS Trend
FROM TopRank AS TP join TrendCalc AS TC ON TP.ProductName = TC.ProductName AND TP.TerritoryName = TC.TerritoryName
WHERE TerritoryRank <= 3)

SELECT * 
FROM Final
ORDER BY TerritoryName, TerritoryRank;
           




