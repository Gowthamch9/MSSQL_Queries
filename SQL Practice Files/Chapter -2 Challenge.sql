SELECT Name as VendorName
FROM Purchasing.Vendor
WHERE (Name LIKE 'C%') AND ((Name LIKE '%Bike%') OR (Name Like '%Bicycle%'));