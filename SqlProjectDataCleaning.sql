--Cleaning Data in Sql:
SElect * from NashvilleHousing;

--Changing Date Format removing time
SElect SaleDate,convert(Date,SaleDate)from NashvilleHousing;
Update NashvilleHousing set SaleDate = convert(Date,SaleDate);
--Update not working sometime 
--Alter statment is used instead
Alter table NashvilleHousing add SaleDateConverted Date;
Update NashvilleHousing set SaleDateConverted = convert(Date,SaleDate);
SElect SaleDate,SaleDateConverted from NashvilleHousing;
-- filling Property Address
SElect PropertyAddress from NashvilleHousing where PropertyAddress is null;
SElect * from NashvilleHousing where PropertyAddress is null;
--Using ParcelID for filling address 
Select nh1.ParcelID,nh1.PropertyAddress,nh2.ParcelID,nh2.PropertyAddress,
isnull(nh1.PropertyAddress,nh2.PropertyAddress) from NashvilleHousing nh1 inner join NashvilleHousing nh2
on nh1.ParcelID = nh2.ParcelID and nh1.[UniqueID ] <> nh2.[UniqueID ]
where nh1.PropertyAddress is null

Update nh1 set PropertyAddress = isnull(nh1.PropertyAddress,nh2.PropertyAddress)
from NashvilleHousing nh1 inner join NashvilleHousing nh2
on nh1.ParcelID = nh2.ParcelID and nh1.[UniqueID ] <> nh2.[UniqueID ]
where nh1.PropertyAddress is null;


Select * from NashvilleHousing;
--Breaking Address into different columns:
SElect PropertyAddress from NashvilleHousing;

Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as address
from NashvilleHousing;

Alter table NashvilleHousing add PropertySplitAddress varchar(255);
Update NashvilleHousing set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1);



Alter table NashvilleHousing add PropertySplitCity varchar(100);
Update NashvilleHousing set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress));

Select PropertyAddress, PropertySplitAddress,PropertySplitCity from NashvilleHousing

--Dividing owner addresses
Select OwnerAddress from NashvilleHousing;


Select PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing;

Alter table NashvilleHousing add OwnerSplitAddress varchar(255);
Update NashvilleHousing set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3);



Alter table NashvilleHousing add OwnerSplitCity varchar(100);
Update NashvilleHousing set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2);

Alter table NashvilleHousing add OwnerSplitState varchar(100);
Update NashvilleHousing set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1);

Select  OwnerSplitAddress,OwnerSplitCity,OwnerSplitState from NashvilleHousing

--Change SoldAsVacant as to  Yes and No only
Select Distinct(SoldAsVacant),count(SoldAsVacant) as NumberOfOccurence from NashvilleHousing
 group by SoldAsVacant;


 Select SoldAsVacant,
	Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No' 
	else SoldAsVacant
	End
 from NashvilleHousing;


 Update NashvilleHousing set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No' 
	else SoldAsVacant
	End;

Select Distinct(SoldAsVacant),count(SoldAsVacant) as NumberOfOccurence from NashvilleHousing
 group by SoldAsVacant;

--Remove Duplicate:
with RowDupCte as(
Select *,
ROW_NUMBER() over (
Partition by ParcelID,PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by uniqueID
) row_num
from NashvilleHousing
 )
Delete  from RowDupCte where row_num>1;
with RowDupCte as(
Select *,
ROW_NUMBER() over (
Partition by ParcelID,PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by uniqueID
) row_num
from NashvilleHousing
 )
 Select *  from RowDupCte where row_num>1;


 --Delete Unused Column
 Select * from NashvilleHousing;

 alter table NashvilleHousing drop column OwnerAddress,
 PropertyAddress,TaxDistrict;
 alter table NashvilleHousing drop column
 SaleDate;
Select * from NashvilleHousing;
