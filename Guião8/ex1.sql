DBCC FREEPROCCACHE;
DBCC DROPCLEANBUFFERS;
GO
--Query: select * from Production.WorkOrder

--Query: select * from Production.WorkOrder where WorkOrderID=1234

--Query: SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010


--Query: SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591
CREATE INDEX idx ON Production.WorkOrder(ProductID, StartDate);
--Query: SELECT * FROM Production.WorkOrder WHERE StartDate = '2007-06-25'

--Query: SELECT * FROM Production.WorkOrder WHERE ProductID = 757

--Query1: SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757
--Query2: SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945
--Query3: SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'
--Query: SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'
Query: SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2006-01-04'

DROP INDEX Production.WorkOrder.idx