SELECT *
from HumanResources.Department
WHERE GroupName <> 'Executive General and Administration'
;

SELECT *
from HumanResources.Department
WHERE GroupName = 'Executive General and Administration'
;

SELECT * 
FROM HumanResources.Department
WHERE GroupName <> 'Executive General and Administration' AND  DepartmentID < 9
;

SELECT * 
FROM HumanResources.Department
WHERE GroupName IN ('Research and Development', 'Manufacturing')
;