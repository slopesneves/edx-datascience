-- Challenge 1: Retrieve Regional Sales Totals
SELECT StateProvince, CountryRegion, City, SUM(soh.TotalDue) AS Revenue, GROUPING_ID(StateProvince, CountryRegion, City) AS Level
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY 
ROLLUP(StateProvince, CountryRegion, City)
ORDER BY Level DESC, CountryRegion, StateProvince, City;

-- Challenge 2: Retrieve Customer Sales Revenue by Category
SELECT * FROM (
		SELECT c.CompanyName, ParentProductCategoryName, LineTotal
		FROM SalesLT.Customer c
		JOIN SalesLT.SalesOrderHeader soh on c.CustomerID = soh.CustomerID
		JOIN SalesLT.SalesOrderDetail sod on sod.SalesOrderID = soh.SalesOrderID
		JOIN SalesLT.Product p on p.ProductID = sod.ProductID
		JOIN SalesLT.vGetAllCategories cat on cat.ProductCategoryID = p.ProductCategoryID
	) AS CPL
PIVOT(SUM(LineTotal) FOR ParentProductCategoryName IN([Accessories], [Bikes], [Clothing], [Components])) AS PivotTable
ORDER BY CompanyName