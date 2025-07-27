--String Concatination
SELECT FirstName, 
       LastName,  
       CONCAT(FirstName,' ',MiddleName, ' ', LastName) AS FullName,
	   CONCAT_WS(' ', FirstName, MiddleName, LastName) AS FullNameWithSeparator
FROM Person.Person

SELECT FirstName, LastName, (FirstName + ' ' + LastName) AS FullName
FROM Person.Person

--UPPER, LOWER, LEN, LEFT, RIGHT, TRIM, LTRIM, RTRIM Functions
SELECT UPPER(FirstName) AS FirstName,
	   UPPER(LastName) AS LastName,
	   LOWER(FirstName) AS FirstName,
	   LOWER(LastName) AS LastName, 
	   LEN(FirstName) AS LenghtofFirstName,
	   LEFT(FirstName, 3) AS FirstThreeLetters,
	   RIGHT(LastName, 3) AS LastThreeLetters,
	   TRIM(LastName) AS TrimmedName
FROM Person.Person

--Math Functions- ROUND, CEILING, FLOOR
SELECT BusinessEntityID,
       SalesYTD,
	   ROUND(SalesYTD,2) AS Round2,
	   ROUND(SalesYTD,-2) AS RoundHundreds,
	   CEILING(SalesYTD) AS RoundCeiling,
	   FLOOR(SalesYTD) AS RoundFloor
FROM Sales.SalesPerson

--GREATEST & LEAST Functions
SELECT FirstName, LastName,
       GREATEST(FirstName, LastName) AS 'Highest Alphabetical',
	   LEAST(FirstName, LastName) AS 'Lowest Alphabetical'
FROM Person.Person

SELECT BusinessEntityID,
       VacationHours,
	   SickLeaveHours,
	   GREATEST(VacationHours, SickLeaveHours) AS 'Greatest',
	   LEAST(VacationHours, SickLeaveHours) AS 'Least',
	   IIF(GREATEST(VacationHours, SickLeaveHours) = SickLeaveHours, 'Sick', 'Vacation') AS 'Which is Higher?'
FROM HumanResources.Employee

--DATE Functions
SELECT BusinessEntityID
      ,HireDate
	  ,YEAR(HireDate) AS HireYear
	  ,MONTH(HireDate) AS HireMonth
	  ,DAY(HireDate) AS HireDay
	  ,DATEDIFF(day, HireDate, GETDATE()) AS Daysworked
	  ,DATEDIFF(year, HireDate, GETDATE()) AS Yearsworked
	  ,DATEDIFF(month, HireDate, GETDATE()) AS Monthsworked
	  ,DATEADD(year, 25, HireDate) AS '25YearsAnniversary'
FROM HumanResources.Employee


SELECT YEAR(HireDate) AS HireYear
	  ,Count(*) AS TotalNumberofPeople
FROM HumanResources.Employee
GROUP BY YEAR(HireDate)
ORDER BY TotalNumberofPeople DESC;

SELECT GETDATE();
SELECT GETUTCDATE();

--DATE FORMAT
SELECT BusinessEntityID
      ,HireDate
	  ,FORMAT(HireDate, 'dddd')
	  ,FORMAT(HireDate, 'ddd')
	  ,FORMAT(HireDate, 'dd')
	  ,FORMAT(HireDate, 'd')
	  ,FORMAT(HireDate, 'dddd, MMMM dd, yyyy')
	  ,FORMAT(HireDate, 'MMMM')
	  ,FORMAT(HireDate, 'MMM')
	  ,FORMAT(HireDate, 'MM')
	  ,FORMAT(HireDate, 'M')
	  ,FORMAT(HireDate, 'yyyy')
	  ,FORMAT(HireDate, 'yyy')
	  ,FORMAT(HireDate, 'yy')
	  ,FORMAT(HireDate, 'y')
FROM HumanResources.Employee

--Date Buckets
--Declared the Starting Date to 2001-05-15
DECLARE @Origin DATE = '2001-05-15';
SELECT BusinessEntityID
      ,HireDate
	  ,FORMAT(HireDate, 'dddd') AS HireDay
	  ,DATE_BUCKET(WEEK, 1, HireDate, @Origin) AS WEEKBUCKETDATE
	  ,FORMAT(DATE_BUCKET(WEEK, 1, HireDate, @Origin), 'dddd') AS WeekBucketDay
FROM HumanResources.Employee;

--Pull Random Records with NEWID
SELECT TOP 10 WorkOrderID
      ,NEWID() AS NewID
FROM Production.WorkOrder
ORDER BY NewID;

--Generating a Series of Values
USE AdventureWorks2019
GO 
SELECT compatibility_level
FROM sys.databases WHERE name = 'AdventureWorks2019';
GO

--150--

ALTER DATABASE AdventureWorks2019
SET compatibility_level = 160;
GO

SELECT Value
FROM GENERATE_SERIES(1,10);

SELECT Value
FROM GENERATE_SERIES(0,100,5);

--Set Varibles to create a list from 0.0 to 1.0 incrementing by 0.1
Declare @start decimal(2,1) = 0.0;
Declare @stop decimal(2,1) = 1.0;
Declare @increment decimal(2,1) = 0.1;
SELECT value
FROM GENERATE_SERIES(@start, @stop, @increment);

--IIF Logic
SELECT BusinessEntityID
      ,SalesYTD
	  ,IIF(SalesYTD > 2000000,' Has Met Goal', 'Has Not Met Goal') AS Status
FROM Sales.SalesPerson
ORDER BY SalesYTD DESC;

SELECT IIF(SalesYTD > 2000000,' Has Met Goal', 'Has Not Met Goal') AS Status, Count(*)
FROM Sales.SalesPerson
GROUP BY IIF(SalesYTD > 2000000,' Has Met Goal', 'Has Not Met Goal')


--CASE STATEMENTS
SELECT ProductModelID
      ,ProductDescriptionID
	  ,CultureID
	  ,CASE CultureID
	     WHEN 'ar' THEN 'Arabic'
		 WHEN 'en' THEN 'English'
		 WHEN 'es' THEN 'Spanish'
		 WHEN 'fr' THEN 'French'
		 WHEN 'th' THEN 'Thai'
	     WHEN 'he' THEN 'Hebrew'
		 WHEN 'zh-cht' THEN 'Chinese'
		 ELSE 'Undefined'
       END AS CultureName
FROM Production.ProductModelProductDescriptionCulture