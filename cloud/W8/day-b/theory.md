## So sánh VM và Container

- `VM`: chứa OS riêng, nặng, tốn tài nguyên, Isolate mạnh hơn
- `Container`: dùng chung kernel của host OS, nhẹ, khởi động nhanh, Isolate nhẹ hơn

## So sánh Image và Container

- `Image`: Template, giống AMI trên AWS
- `Container`: Instance được tạo từ Image

`Dockerfile -> Image -> Container`

## Kubernetes

- Nền tảng orchestration dùng để quản lý và vận hành container ở quy mô lớn

`Docker = chạy container`

`Kubernetes = quản lý container`

## Ví dụ

- `Desired = 3 Pods`
- `Current = 2 Pods`

`→ Kubernetes tạo thêm 1 Pod để đạt Desired State`

---

## Cluster

- Tập hợp nhiều Node được Kubernetes quản lý

## Node

- Máy (VM hoặc physical server) chạy Pod

## Pod

- Đơn vị deploy nhỏ nhất của Kubernetes
- Chứa 1 hoặc nhiều container
- Các container cùng Pod dùng chung IP, network và volume

## Deployment

- Quản lý Pod
- Đảm bảo số lượng Pod luôn đúng theo cấu hình
- Self-healing
- Scale
- Rolling Update

## Service (≈ ALB Target Group + DNS ổn định)

- Cung cấp địa chỉ cố định cho Pod
- Load balance traffic giữa các Pod
- Giúp truy cập Pod mà không cần quan tâm IP Pod thay đổi

## Ingress (≈ ALB + Listener Rules)

- Expose Service ra ngoài Internet
- Routing request theo domain hoặc path
- Điểm vào của traffic từ bên ngoài cluster

## ConfigMap

- Lưu cấu hình không nhạy cảm
- Tách config khỏi code

## Secret

- Lưu dữ liệu nhạy cảm
- Tách secret khỏi code

## Liveness Probe

- App còn sống không
- Fail → restart Pod

## Readiness Probe

- App sẵn sàng nhận traffic chưa
- Fail → không nhận traffic

## Startup Probe

- App khởi động xong chưa
- Dùng cho ứng dụng boot chậm

## Volume

- Lưu trữ dữ liệu cho Pod
- Pod restart/recreate dữ liệu vẫn còn

## NetworkPolicy

- Firewall cho Pod
- Kiểm soát Pod nào được phép giao tiếp với Pod nào
