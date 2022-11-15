-- view data
select * from Housing


-- standardize date format

	-- method 1, direct conversion not working here
select SaleDate, convert(Date,SaleDate)
from Housing

Update Housing
set SaleDate=convert(Date,SaleDate)

	-- method 2, add new column then update table
Alter Table Housing
Add SaleDateConvert Date;

Update Housing
set SaleDateConvert = convert(Date,SaleDate)

select SaleDate, SaleDateConvert from Housing -- works


-- populate property address data using ParcelID
select *
from Housing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from Housing a
join Housing b 
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] -- will not join rows with same parcelID if different uniqueID
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Housing a
join Housing b 
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Updating addresses to multiple columns
select PropertyAddress
from Housing

select
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address,
substring (PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
from Housing

Alter Table Housing
Add PropertySplitAddress nvarchar(255);

Update Housing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) 

Alter Table Housing
Add PropertySplitCity nvarchar(255);

Update Housing
set PropertySplitCity = substring (PropertyAddress, charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) 

select *
from Housing


	-- !!using parsename to separate
select OwnerAddress from Housing

select
Parsename(Replace(OwnerAddress, ',', '.'),3)
,Parsename(Replace(OwnerAddress, ',', '.'),2)
,Parsename(Replace(OwnerAddress, ',', '.'),1)
from Housing

Alter Table Housing
Add OwnerSplitAddress nvarchar(255);

Update Housing
set OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.'),3)

Alter Table Housing
Add OwnerSplitCity nvarchar(255);

Update Housing
set OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'),2)

Alter Table Housing
Add OwnerSplitState nvarchar(255);

Update Housing
set OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.'),1)


-- standardize SoldAsVacant column

select distinct(SoldAsVacant), count(SoldAsVacant)
from Housing -- returns 4 variables
group by SoldAsVacant
order by 2 desc

Select SoldAsVacant
, CASE when SoldAsVacant='Y' then 'Yes'
	   when SoldAsVacant='N' then 'No'
	   else SoldAsVacant
	   END
from Housing

Update Housing -- direct conversion working here
SET SoldAsVacant = CASE when SoldAsVacant='Y' then 'Yes'
	   when SoldAsVacant='N' then 'No'
	   else SoldAsVacant
	   END


-- remove duplicates, should use temp table/CTE

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertySplitAddress,
				 SalePrice,
				 SaleDateConvert,
				 LegalReference
				 ORDER BY
					 UniqueID
					 ) row_num
from Housing
)
Select *
from RowNumCTE
where row_num > 1

-- delete unused columns

Alter Table Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Alter Table Housing
Drop Column SaleDate

select * from housing









