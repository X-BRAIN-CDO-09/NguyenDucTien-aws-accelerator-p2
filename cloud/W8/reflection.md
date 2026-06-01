# W8 Reflection

## Day A: Terraform

### 1. IaC Overview

IaC (Infrastructure as Code) là cách quản lý hạ tầng bằng code thay vì thao tác thủ công trên console.

Lợi ích chính:
- Giảm lỗi do thao tác tay.
- Tái sử dụng cấu hình qua template/module.
- Dễ review, quản lý version, và tự động hóa qua CI/CD.

### 2. HCL Syntax

Terraform sử dụng HCL (HashiCorp Configuration Language), với cấu trúc chính theo dạng `block`.

Các block phổ biến:
- `terraform`: Cấu hình phiên bản Terraform/provider.
- `provider`: Khai báo nhà cung cấp (AWS, Azure, GCP...).
- `resource`: Định nghĩa tài nguyên cần tạo.
- `variable` và `output`: Nhận đầu vào và xuất kết quả đầu ra.

### 3. Workflow Basics

- `terraform init`: Khởi tạo thư mục làm việc, tải provider/module và metadata cần thiết (không tải resource thật).
- `terraform plan`: So sánh code với state/infrastructure thực tế và hiển thị trước các thay đổi `add/change/destroy`.
- `terraform apply`: Thực thi thay đổi theo plan để tạo/cập nhật resource.
- `terraform destroy`: Xóa toàn bộ resource Terraform đang quản lý trong scope hiện tại.

### 4. Lưu ý quan trọng

- Hạn chế chỉnh tay trực tiếp trên cloud console sau khi đã dùng IaC.
- Nếu chỉnh tay, code và thực tế sẽ bị lệch (drift), khiến `plan/apply` khó kiểm soát.
- Ưu tiên cập nhật qua code để đảm bảo tính nhất quán và truy vết lịch sử thay đổi.
