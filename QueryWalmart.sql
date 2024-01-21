CREATE DATABASE Walmart;

SELECT * From Walmart..Sales;
SELECT * From Walmart..Products;
SELECT * From Walmart..Inventory;

SELECT StoreId, UnitPrice, Quantity FROM Walmart..Sales;

--- Product yang masih banyak tersisa ---
SELECT Products.ProductName, Inventory.QuantityAvailable 
From Walmart..Inventory
INNER JOIN Walmart..Products ON Products.ProductId = Inventory.ProductId
ORDER BY QuantityAvailable DESC;

--- Total Cost ---
ALTER TABLE Walmart..Sales
ADD TotalCost int;
SELECT StoreId, UnitPrice, Quantity, TotalCost FROM Walmart..Sales;
SELECT StoreId, UnitPrice, Quantity, Quantity * UnitPrice AS TotalCost FROM Walmart..Sales;


--- Jumlah Produk yang terjual ---
SELECT*FROM Walmart..Inventory;
SELECT StoreId, StoreName, QuantityAvailable FROM Walmart..Inventory;
ALTER TABLE Walmart..Inventory
ADD QuantitySaled Int;


--- jumlah barang yang terjual berdasarkan store name ---
SELECT StoreId, StoreName, QuantityAvailable, QuantitySaled FROM Walmart..Inventory;
SELECT Inventory.StoreName, Sales.Quantity, Inventory.QuantityAvailable, CAST(Sales.Quantity AS BIGINT)-CAST(Inventory.QuantityAvailable AS BIGINT) AS QuantitySaled
FROM Walmart..Sales
INNER JOIN Walmart..Inventory ON Sales.StoreId = Inventory.StoreId;


-- jumlah produk yang dijual dalam sebulan ---
SELECT Sales.ProductId,
	DATEPART(MM,Date) AS MonthDate,
	AVG(CAST(Sales.Quantity AS BIGINT) - CAST (Inventory.QuantityAvailable AS BIGINT)) OVER (PARTITION BY SalesID, DATEPART(mm,Date)) AS MonthlySales
FROM Walmart..Sales
INNER JOIN Walmart..Inventory ON Sales.StoreId = Inventory.StoreId;

-- Rata-rata jumlah produk yang dijual dalam seminggu ---
SELECT Sales.ProductId,
	DATEPART(wk,Date) AS WeekDate,
	AVG(CAST(Sales.Quantity AS BIGINT) - CAST (Inventory.QuantityAvailable AS BIGINT)) OVER (PARTITION BY SalesID, DATEPART(mm,Date)) AS WeeklySales
FROM Walmart..Sales
INNER JOIN Walmart..Inventory ON Sales.StoreId = Inventory.StoreId;

--- Presentase Produk apa yang memiliki keuntungan terbesar ---
SELECT Products.ProductName, ((Sales.UnitPrice - Products.ProductCost)/Sales.UnitPrice)*100 AS ProfitMargin
From Walmart..Sales
INNER JOIN Walmart..Products ON Products.ProductId = Sales.ProductId
ORDER BY ProfitMargin DESC;



