select ConvertedDate
from PortfolioProject.dbo.NashvilleHousing

--Standardize date format
select SaleDate, convert(date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add ConvertedDate date;

update NashvilleHousing
set ConvertedDate= convert(date, SaleDate)


--Populate Property address data
select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ] 
where a.PropertyAddress is null

update a
set PropertyAddress= ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ] 
where a.PropertyAddress is null

select*
from PortfolioProject.dbo.NashvilleHousing

--Breaking address
select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
where PropertyAddress is null

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as addressa
from PortfolioProject.dbo.NashvilleHousing
order by addressa

alter table PortfolioProject.dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table PortfolioProject.dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) 

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select 
parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitAddress= parsename(replace(OwnerAddress,',','.'),3)

alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity= parsename(replace(OwnerAddress,',','.'),2)

alter table PortfolioProject.dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState= parsename(replace(OwnerAddress,',','.'),1)


--Changing Y/N to Yes and No in soldasVacant

select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant,
case
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end
from PortfolioProject.dbo.NashvilleHousing


update PortfolioProject.dbo.NashvilleHousing
set  SoldAsVacant=
case
when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end


-- Removing Duplicates
with RowNumCTE as(
select *,
ROW_NUMBER() over(
partition by ParcelId,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by
UniqueID)
row_num
from PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
select *
from RowNumCTE
where row_num>1
--order by PropertyAddress

--Removing Unused Column
select *
from PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column PropertyAddress,TaxDistrict,OwnerAddress
