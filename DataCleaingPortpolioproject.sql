/*
cleaing data in sql queries
*/

select * 
from NashvilleHousing

--standardize date format

select SalesDate2,CONVERT (Date,saledate)
from NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SalesDate2 Date;


update NashvilleHousing
SET SalesDate2 =CONVERT (Date,saledate)


--Populate property Address data

--select *
--from NashvilleHousing
--where PropertyAddress is null



select n1.ParcelID,n1.PropertyAddress,n2.ParcelID,n2.PropertyAddress,ISNULL(n1.PropertyAddress,n2.PropertyAddress)
from NashvilleHousing n1
 JOIN
	NashvilleHousing n2
 ON n1.ParcelID=n2.ParcelID
 AND n1.[UniqueID ]<>n2.[UniqueID ]
WHERE n1.PropertyAddress IS NULL

update n1
SET PropertyAddress =ISNULL(n1.PropertyAddress,n2.PropertyAddress)
from NashvilleHousing n1
 JOIN
	NashvilleHousing n2
 ON n1.ParcelID=n2.ParcelID
 AND n1.[UniqueID ]<>n2.[UniqueID ]
 WHERE n1.PropertyAddress IS NULL 

 
 --Breaking out address into indiviual columns Property Adress(Address,State,City)

 select PropertyAddress
 from PortfolioProject..NashvilleHousing

 select 
 SUBSTRING(PropertyAddress ,1,CHARINDEX(',',PropertyAddress)-1) as PropertysplitAddress
 ,SUBSTRING(PropertyAddress ,CHARINDEX(',',PropertyAddress)+1,LEN( PropertyAddress))as PropertysplitCity
 from NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertysplitAddress NVARCHAR(255);

update NashvilleHousing
SET PropertysplitAddress =SUBSTRING(PropertyAddress ,1,CHARINDEX(',',PropertyAddress)-1) 



 ALTER TABLE NashvilleHousing
ADD PropertysplitCity NVARCHAR(255);

update NashvilleHousing
SET PropertysplitCity =SUBSTRING(PropertyAddress ,CHARINDEX(',',PropertyAddress)+1,LEN( PropertyAddress))


select * from NashvilleHousing



 --Breaking out address into indiviual columns Owner Adress(Address,State,City)

 select OwnerAddress from NashvilleHousing


SELECT 
PARSENAME (REPLACE (OwnerAddress,',','.'),3)as OwnersplitAddress,
PARSENAME (REPLACE (OwnerAddress,',','.'),2)as OwnersplitCity,
PARSENAME (REPLACE (OwnerAddress,',','.'),1)as OwnersplitState
 from NashvilleHousing


 
 ALTER TABLE NashvilleHousing
ADD OwnersplitAddress NVARCHAR(255);

update NashvilleHousing
SET OwnersplitAddress =PARSENAME (REPLACE (OwnerAddress,',','.'),3)


 ALTER TABLE NashvilleHousing
ADD OwnersplitCity NVARCHAR(255);

update NashvilleHousing
SET OwnersplitCity =PARSENAME (REPLACE (OwnerAddress,',','.'),2)


 ALTER TABLE NashvilleHousing
ADD OwnersplitState NVARCHAR(255);

update NashvilleHousing
SET OwnersplitState =PARSENAME (REPLACE (OwnerAddress,',','.'),1)


 select * from NashvilleHousing


 --change Y and N to YES and NO in 'SoldAsVacent' field

select SoldAsVacant,Count(SoldAsVacant)
From NashvilleHousing
group by soldAsVacant
order by 2

Select SoldAsVacant,
Case when soldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant ='N' then 'No'
	 else soldAsVacant
	 END
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant= Case when soldAsVacant = 'Y' then 'Yes'
	 when SoldAsVacant ='N' then 'No'
	 else soldAsVacant
	 END


--Remove Duplicates
with rownumCTE AS(

select *,
	ROW_NUMBER()OVER(
	PARTITION BY parcelid,
				propertyaddress,
				saledate,
				saleprice,
				legalreference
			ORDER BY
				UniqueID
				)rownum
from NashvilleHousing
)

--DELETE 
--from rownumCTE
--where rownum >1


select * 
from rownumCTE
where rownum >1
order by PropertyAddress


--Delete unused columns

select * from NashvilleHousing


Alter table NashvilleHousing
DROP COLUMN propertyaddress,owneraddress,TaxDistrict,SaleDate