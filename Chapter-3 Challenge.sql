SELECT * FROM Person.Address

SELECT * FROM Person.StateProvince

SELECT * FROM Person.CountryRegion


SELECT A.AddressLine1 AS 'Address', A.City, B.Name AS 'State/Province Name', C.Name AS 'Country Name'
FROM Person.Address AS A JOIN Person.StateProvince AS B ON A.StateProvinceID = B.StateProvinceID JOIN Person.CountryRegion AS C ON B.CountryRegionCode = C.CountryRegionCode
WHERE B.Name = 'Texas';