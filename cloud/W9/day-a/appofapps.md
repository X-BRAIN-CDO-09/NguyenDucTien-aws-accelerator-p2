# App of Apps

## Là gì

- `App of Apps` là pattern trong Argo CD.
- Ý tưởng là có một `Application` cha quản lý nhiều `Application` con.
- App cha sẽ trỏ tới thư mục git chứa danh sách các app con, rồi Argo CD tạo và sync các app đó.

## Dùng khi nào

- Khi cần quản lý nhiều ứng dụng hoặc nhiều thành phần hạ tầng trong cùng một cụm Kubernetes.
- Khi muốn bootstrap cả cluster từ một repo gốc.
- Khi muốn tách từng app ra file riêng nhưng vẫn có một điểm quản lý tập trung.

## Cách hoạt động

1. Tạo một Argo CD `Application` cha.
2. App cha trỏ tới repo/thư mục chứa manifest của các `Application` con.
3. Argo CD sync app cha.
4. Các app con được tạo ra và tiếp tục sync resource của chính chúng.

## Ví dụ dễ hiểu

- App cha: quản lý danh sách `frontend`, `backend`, `monitoring`, `ingress`.
- App con `frontend`: sync deployment và service của frontend.
- App con `monitoring`: sync Prometheus, Grafana.

## Ưu điểm

- Quản lý nhiều app theo cấu trúc rõ ràng.
- Dễ bootstrap môi trường mới.
- Dễ tách quyền quản lý theo từng app hoặc từng team.
- Mọi thứ vẫn nằm trong git, dễ audit và rollback.

## Nhược điểm

- Nếu tổ chức repo kém thì khá rối.
- Quan hệ cha con nhiều tầng có thể làm khó debug.
- Cần thống nhất naming, folder structure và cách chia app ngay từ đầu.

## Kết luận ngắn

- `App of Apps` phù hợp khi số lượng application nhiều và cần quản lý tập trung.
- Đây là pattern rất hay dùng với Argo CD để quản lý cluster theo kiểu GitOps.
