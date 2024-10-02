use House

------ Xem tổng thể dữ liệu
select * from House
order by UniqueID

------ Kiểm tra kiểu dữ liệu của các trường
exec sp_help 'House'

------ Đổi kiểu dữ liệu trường SoldAsVacant
alter table House
alter column SoldAsVacant varchar(3)

------ Thay giá trị trường SoldAsVacant
update House
set SoldAsVacant = case 
    when SoldAsVacant = 1 then 'Yes'
    when SoldAsVacant = 0 then 'No'
end
where SoldAsVacant is not null

------ Kiểm tra cột chứa giá trị null
SELECT 
    COUNT(CASE WHEN PropertyAddress IS NULL THEN 1 END) AS NullCount_PropertyAddress,
    COUNT(CASE WHEN SaleDate IS NULL THEN 1 END) AS NullCount_SaleDate,
	COUNT(CASE WHEN SalePrice IS NULL THEN 1 END) AS NullCount_SalePrice,
	COUNT(CASE WHEN LegalReference IS NULL THEN 1 END) AS NullCount_LegalReference,
	COUNT(CASE WHEN SoldAsVacant IS NULL THEN 1 END) AS NullCount_SoldAsVacant,
	COUNT(CASE WHEN OwnerName IS NULL THEN 1 END) AS NullCount_OwnerName,
	COUNT(CASE WHEN OwnerAddress IS NULL THEN 1 END) AS NullCount_OwnerAddress,
	COUNT(CASE WHEN Acreage IS NULL THEN 1 END) AS NullCount_Acreage,
	COUNT(CASE WHEN TaxDistrict IS NULL THEN 1 END) AS NullCount_TaxDistrict,
	COUNT(CASE WHEN LandValue IS NULL THEN 1 END) AS NullCount_LandValue,
	COUNT(CASE WHEN BuildingValue IS NULL THEN 1 END) AS NullCount_BuildingValue,
	COUNT(CASE WHEN TotalValue IS NULL THEN 1 END) AS NullCount_TotalValue,
	COUNT(CASE WHEN YearBuilt IS NULL THEN 1 END) AS NullCount_YearBuilt,
	COUNT(CASE WHEN Bedrooms IS NULL THEN 1 END) AS NullCount_Bedrooms,
	COUNT(CASE WHEN FullBath IS NULL THEN 1 END) AS NullCount_FullBath,
	COUNT(CASE WHEN HalfBath IS NULL THEN 1 END) AS NullCount_HalfBath
FROM House;

------ Bổ sung dữ liệu vào trường ProperAddress
update a
set a.PropertyAddress = b.PropertyAddress
from House a
join House b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

------ Kiểm tra trường PropertyAddress và OwnerAddress có bao nhiêu giá trị con trước khi tách chuỗi
select 
    max(len(PropertyAddress) - len(replace(PropertyAddress, ',', ''))) as Max_PropertyAddressCount,
	max(len(OwnerAddress) - len(replace(OwnerAddress, ',', ''))) as Max_OwnerAddressCount
from House;
----- Phát hiện PropertyAddress có 2 giá trị con là số nhà và thành phố, OwnerAddress có 3 giá trị con là số nhà, thành phố và bang

------ Sử dụng CTE tách chuỗi cho PropertyAddress và đưa vào bảng tạm #temp
with SplitProAdd as (
    select 
        UniqueID,
        trim(value) as split_proadd_value,  
        row_number() over(partition by UniqueID order by (select null)) as rn
    from House
    cross apply string_split(PropertyAddress, ',')
)
select 
    h.UniqueID,
    max(case when sp.rn = 1 then sp.split_proadd_value end) as PropertyStreet,
    max(case when sp.rn = 2 then sp.split_proadd_value end) as PropertyCity
into #temp
from House h
left join SplitProAdd sp on h.UniqueID = sp.UniqueID
group by h.UniqueID

------ Kiểm tra bảng tạm #temp vừa tạo
select *
from #temp
order by UniqueID

------ Thêm trường cho bảng House
alter table House
add PropertyStreet varchar(50),
PropertyCity varchar(50)

------ Truyền giá trị ở bảng tạo #temp vào trường vừa thêm ở bảng House
update h
set h.PropertyStreet = t.PropertyStreet,
	h.PropertyCity = t.PropertyCity
from House h
inner join #temp t on h.UniqueID = t.UniqueID

------ Sử dụng CTE tách chuỗi cho OwnerAddress và đưa vào bảng tạm #temp1
with SplitOwnAdd as (
    select 
        UniqueID,
        trim(value) as split_ownadd_value,  
        row_number() over(partition by UniqueID order by (select null)) as rn
    from House
    cross apply string_split(OwnerAddress, ',')
)
select 
    h.UniqueID,
    max(case when so.rn = 1 then so.split_ownadd_value end) as OwnerStreet,
    max(case when so.rn = 2 then so.split_ownadd_value end) as OwnerCity,
	max(case when so.rn = 3 then so.split_ownadd_value end) as OwnerState
into #temp1
from House h
left join SplitOwnAdd so on h.UniqueID = so.UniqueID
group by h.UniqueID

------ Kiểm tra bảng tạm #temp1 vừa tạo
select *
from #temp1
order by UniqueID

------ Thêm trường cho bảng House
alter table House
add OwnerStreet varchar(50),
OwnerCity varchar(50),
OwnerState varchar(50)

------ Truyền giá trị ở bảng tạo #temp1 vào trường vừa thêm ở bảng House
update h
set h.OwnerStreet = t.OwnerStreet,
	h.OwnerCity = t.OwnerCity,
	h.OwnerState = t.OwnerState
from House h
inner join #temp1 t on h.UniqueID = t.UniqueID

------ Sử dụng CTE kiểm tra các bản ghi trung lặp các giá trị quan trọng
with CountDuplicatesCTE as (
    select 
        *,
        row_number() over (
            partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            order by UniqueID
        ) as row_num
    from House
)
select *
from CountDuplicatesCTE
where row_num > 1; ---104 duplicates

------ Sử dụng CTE xóa các giá trị trùng lặp bên trên
with DeleteDuplicatesCTE as (
    select 
        *,
        row_number() over (
            partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            order by UniqueID
        ) as row_num
    from House
)
delete from DeleteDuplicatesCTE 
where row_num > 1;



