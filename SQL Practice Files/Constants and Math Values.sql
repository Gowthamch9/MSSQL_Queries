SELECT Name, 
ProductNumber, 
'Adventure Works' AS Manufacturer,
ListPrice, 
ListPrice * 0.85 AS SalesPrice
FROM Production.Product
WHERE ListPrice <> 0