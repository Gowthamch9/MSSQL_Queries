SELECT FirstName
FROM Person.Person
WHERE FirstName LIKE 'G%'
ORDER BY FirstName;

SELECT FirstName
FROM Person.Person
WHERE FirstName LIKE '[^A-C]__';
