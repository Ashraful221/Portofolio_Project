/*
Cleaning Data in SQL Queries
*/


Select *
From Portfolio_Project..Nashville_housing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select saleDateConverted
From Portfolio_Project..Nashville_housing

ALTER TABLE Nashville_housing
Add SaleDateConverted Date;

Update Nashville_housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From Portfolio_Project..Nashville_housing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project..Nashville_housing a
JOIN Portfolio_Project..Nashville_housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Portfolio_Project..Nashville_housing a
JOIN Portfolio_Project..Nashville_housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Portfolio_Project..Nashville_housing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Portfolio_Project..Nashville_housing


ALTER TABLE Nashville_housing
Add PropertySplitAddress Nvarchar(255);

Update Nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville_housing
Add PropertySplitCity Nvarchar(255);

Update Nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Portfolio_Project..Nashville_housing





Select OwnerAddress
From Portfolio_Project..Nashville_housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Portfolio_Project..Nashville_housing



ALTER TABLE Nashville_housing
Add OwnerSplitAddress Nvarchar(255);

Update Nashville_housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville_housing
Add OwnerSplitCity Nvarchar(255);

Update Nashville_housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashville_housing
Add OwnerSplitState Nvarchar(255);

Update Nashville_housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Portfolio_Project..Nashville_housing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio_Project..Nashville_housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Portfolio_Project..Nashville_housing


Update Nashville_housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio_Project..Nashville_housing
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress



Select *
From Portfolio_Project..Nashville_housing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Portfolio_Project..Nashville_housing


ALTER TABLE Portfolio_Project..Nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate