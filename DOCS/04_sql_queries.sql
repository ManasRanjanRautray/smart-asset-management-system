SELECT
    A.AssetTag,
    A.AssetName,
    C.CategoryName,
    L.LocationName,
    V.VendorName,
    A.PurchaseCost,
    A.AssetStatus
FROM dbo.Assets A
INNER JOIN dbo.Categories C
    ON A.CategoryID = C.CategoryID
INNER JOIN dbo.Locations L
    ON A.LocationID = L.LocationID
LEFT JOIN dbo.Vendors V
    ON A.VendorID = V.VendorID;