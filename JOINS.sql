SELECT * 
FROM Person.Person

SELECT * 
FROM Person.PersonPhone

SELECT BusinessEntityID, JobTitle
FROM HumanResources.Employee


SELECT P.BusinessEntityID, P.FirstName, P.LastName, PP.PhoneNumber
FROM Person.Person AS P JOIN Person.PersonPhone AS PP ON P.BusinessEntityID = PP.BusinessEntityID
ORDER BY P.FirstName


SELECT A.Name AS 'DepartmentName', 
       B.Name AS 'AddressName'
From HumanResources.Department AS A CROSS JOIN Person.AddressType AS B;

SELECT A.Name AS 'Home Team',
       B.Name AS 'Away Team'
From HumanResources.Department AS A CROSS JOIN HumanResources.Department AS B
WHERE A.Name <> B.Name;