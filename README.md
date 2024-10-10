# 🏠NashvilleHousing-CleanData

## ✏️Các thao tác chính bao gồm
Dự án tập trung vào việc làm sạch tập dữ liệu thông tin về doanh số bán nhà ở tại Nashville, TN(Tennessee: một tiểu bang nằm ở khu vực phía Đông Nam của Hoa Kỳ) với các thao tác chính bao gồm:
- Sử dụng DQL (Data Query Language): select để truy vấn kiểm tra dữ liệu
- Sử dụng DDL (Data Definition Language): alter để định nghĩa dữ liệu
- Sử dụng DML (Data Manipulation Language): update để đổi kiểu dữ liệu và cập nhật các giá trị và loại bỏ dữ liệu trùng lặp
- Sử dụng join: left join
- Sử dụng CTE tạo bảng tạm
- Sử dụng windown function: row_number(), over() 
- Sử dụng String Function để tách chuỗi địa chỉ nhà thành các trường riêng như số nhà, thành phố, bang

## ✏️Thông tin dữ liệu (Dataset)
- UniqueID: Mã định danh duy nhất cho mỗi bản ghi.
- ParcelID: Mã định danh của lô đất.
- LandUse: Mục đích sử dụng đất (như đất ở, thương mại).
- PropertyAddress: Địa chỉ bất động sản.
- SaleDate: Ngày giao dịch bất động sản.
- SalePrice: Giá bán của bất động sản.
- LegalReference: Số tài liệu pháp lý liên quan đến giao dịch.
- SoldAsVacant: Tình trạng bất động sản (bán khi còn trống hay không).
- OwnerName: Tên chủ sở hữu.
- OwnerAddress: Địa chỉ của chủ sở hữu.
- Acreage: Diện tích đất.
- TaxDistrict: Khu vực tính thuế.
- LandValue: Giá trị của phần đất.
- BuildingValue: Giá trị của các công trình xây dựng trên đất.
- TotalValue: Tổng giá trị của đất và công trình xây dựng.
- YearBuilt: Năm xây dựng công trình.
- Bedrooms: Số phòng ngủ.
- FullBath: Số phòng tắm đầy đủ.
- HalfBath: Số phòng tắm không đầy đủ (chỉ có bồn rửa hoặc nhà vệ sinh).




