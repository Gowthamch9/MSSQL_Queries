SELECT WorkOrderID, ScrappedQty, ISNULL(ScrapReasonID, 100) AS ScrapReason
FROM Production.WorkOrder
;


SELECT WorkOrderID, ScrappedQty, ScrapReasonID
FROM Production.WorkOrder
WHERE ScrapReasonID IS NOT NULL;