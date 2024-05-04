/* Cleaning Data in SQL Queries */

SELECT * 
FROM dbo.[Nashville Housing Data for Data Cleaning ]

-- Standardize Data Format

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM dbo.[Nashville Housing Data for Data Cleaning ]

UPDATE dbo.[Nashville Housing Data for Data Cleaning ]
SET SaleDate = CONVERT(Date,SaleDate)

-- Populate Property Address Data

SELECT * --,PropertyAddress
FROM dbo.[Nashville Housing Data for Data Cleaning ]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.[Nashville Housing Data for Data Cleaning ] AS a
JOIN dbo.[Nashville Housing Data for Data Cleaning ] AS b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID --making sure it is not the same row
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.[Nashville Housing Data for Data Cleaning ] AS a
JOIN dbo.[Nashville Housing Data for Data Cleaning ] AS b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
	WHERE a.PropertyAddress IS NULL


-- Breaking out Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM dbo.[Nashville Housing Data for Data Cleaning ] 

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) AS City
FROM dbo.[Nashville Housing Data for Data Cleaning ]

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning ]
ADD PropertySplitAddress Nvarchar(255)

UPDATE dbo.[Nashville Housing Data for Data Cleaning ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning ]
ADD PropertySplitCity Nvarchar(255)

UPDATE dbo.[Nashville Housing Data for Data Cleaning ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))


SELECT OwnerAddress 
FROM dbo.[Nashville Housing Data for Data Cleaning ]

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM dbo.[Nashville Housing Data for Data Cleaning ]

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning ]
ADD OwnerSplitAddress Nvarchar(255)

UPDATE dbo.[Nashville Housing Data for Data Cleaning ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning ]
ADD OwnerSplitCity Nvarchar(255)

UPDATE dbo.[Nashville Housing Data for Data Cleaning ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning ]
ADD OwnerSplitState Nvarchar(255)

UPDATE dbo.[Nashville Housing Data for Data Cleaning ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

-- Change Y and N to Yes and No in "Sold as Vacant"

SELECT SoldAsVacant 
, CASE SoldAsVacant
		WHEN '1' THEN 'Yes'
	    ELSE 'No' 
	    END
FROM dbo.[Nashville Housing Data for Data Cleaning ]

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning ]
ALTER COLUMN SoldAsVacant nvarchar(50)

UPDATE dbo.[Nashville Housing Data for Data Cleaning ]
SET SoldAsVacant =  CASE SoldAsVacant
		WHEN '1' THEN 'Yes'
	    ELSE 'No' 
	    END
FROM dbo.[Nashville Housing Data for Data Cleaning ]

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY UniqueID) AS row_num

FROM dbo.[Nashville Housing Data for Data Cleaning ]
--ORDER BY ParcelID
)
DELETE 
FROM RowNumCTE
WHERE row_num > 1


-- Delete Unused Columns

ALTER TABLE dbo.[Nashville Housing Data for Data Cleaning ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

SELECT *
FROM dbo.[Nashville Housing Data for Data Cleaning ]
