-- 1: Using the Production.ProductInventory table, 
--    combine the LocationID, Shelf, and Bin values 
--    into a single column with hyphens between each.

SELECT *
FROM Production.ProductInventory

SELECT LocationID
      ,Shelf
      ,Bin
      ,CONCAT_WS('-', LocationID, Shelf, Bin) AS CompleteLocation
FROM Production.ProductInventory

-- 2: Using the HumanResources.Employee table,
--    Locate all of the people hired in February of any year.
--    Then identify the date that their 90 day new hire 
--    performance evaluation is due

SELECT *
FROM HumanResources.Employee

SELECT BusinessEntityID
      ,HireDate
      ,Format(HireDate, 'y') AS HireMonth
      ,DATEADD(DAY, 90, HireDate) AS PerformanceEvaluationDueDate
 FROM HumanResources.Employee    
 WHERE Format(HireDate,'MMMM') = 'February'

 -- 3: View CreditRating information for each vendor in the 
--    Purchasing.Vendor table.  Then use a CASE statement to 
--    translate the 1 - 5 credit rating into the text ratings:
--    poor, below average, average, good, excellent

SELECT *
FROM Purchasing.Vendor

SELECT BusinessEntityID
      ,Name AS VendorName
      ,CreditRating
      ,CASE CreditRating
       WHEN 1 THEN 'Poor'
       WHEN 2 THEN 'Below Average'
       WHEN 3 THEN 'Average'
       WHEN 4 THEN 'Good'
       WHEN 5 THEN 'Excellent'
       END AS CreditRatings
FROM Purchasing.Vendor


-- 4: Select three random people from Sales.SalesPerson.
--    Then use an IIF function to compare their SalesYTD 
--    to the SalesLastYear and indicate whether their 
--    performance has increased or decreased

SELECT *
FROM Sales.SalesPerson

SELECT TOP 3 BusinessEntityID
      ,SalesYTD
      ,SalesLastYear
      ,NEWID() AS NEWID
      ,IIF(SalesYTD > SalesLastYear, 'Increased Performance', 'Decreased Performance')
FROM Sales.SalesPerson
ORDER BY NEWID