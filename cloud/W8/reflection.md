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

## Day B: Container và Kubernetes

### 1. VM, Image và Container

- `VM` có hệ điều hành riêng, cách ly mạnh hơn nhưng nặng và tốn tài nguyên hơn.
- `Container` dùng chung kernel với host, nhẹ hơn, khởi động nhanh hơn nhưng mức cách ly thấp hơn `VM`.
- `Image` là template bất biến để tạo container, tương tự cách `AMI` được dùng để tạo `EC2`.
- Chuỗi cơ bản là `Dockerfile -> Image -> Container`.

### 2. Docker và Kubernetes

- `Docker` tập trung vào việc đóng gói và chạy container.
- `Kubernetes` tập trung vào việc quản lý, điều phối và vận hành container ở quy mô lớn.
- Điểm quan trọng của Kubernetes là luôn cố gắng đưa hệ thống về `desired state`.
- Ví dụ, nếu cấu hình yêu cầu `3 Pods` nhưng thực tế chỉ còn `2 Pods`, Kubernetes sẽ tự tạo thêm để khôi phục trạng thái mong muốn.

### 3. Các thành phần chính trong Kubernetes

- `Cluster`: tập hợp nhiều `Node` được Kubernetes quản lý.
- `Node`: máy chủ hoặc `VM` nơi các `Pod` được chạy.
- `Pod`: đơn vị deploy nhỏ nhất, có thể chứa một hoặc nhiều container dùng chung IP, network và volume.
- `Deployment`: quản lý Pod, hỗ trợ self-healing, scale và rolling update.
- `Service`: cung cấp địa chỉ ổn định cho Pod và phân phối traffic giữa các Pod.
- `Ingress`: mở đường vào từ Internet và định tuyến request theo domain hoặc path.

### 4. Cấu hình, dữ liệu và kiểm tra sức khỏe

- `ConfigMap` dùng để tách cấu hình không nhạy cảm ra khỏi code.
- `Secret` dùng để lưu dữ liệu nhạy cảm thay vì hard-code trong ứng dụng.
- `Volume` giúp dữ liệu vẫn tồn tại khi Pod restart hoặc được recreate.
- `Liveness Probe` kiểm tra ứng dụng còn sống hay không để quyết định restart.
- `Readiness Probe` kiểm tra ứng dụng đã sẵn sàng nhận traffic hay chưa.
- `Startup Probe` hữu ích với ứng dụng cần thời gian khởi động lâu.

### 5. Networking và kiểm soát truy cập

- Luồng truy cập cơ bản có thể hình dung là `Internet -> Ingress -> Service -> Deployment -> Pod`.
- `NetworkPolicy` đóng vai trò như firewall ở mức Pod, kiểm soát Pod nào được phép giao tiếp với Pod nào.
