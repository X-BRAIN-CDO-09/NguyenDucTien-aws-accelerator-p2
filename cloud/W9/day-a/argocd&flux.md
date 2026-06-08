# Argo CD và Flux

## Argo CD là gì

- Argo CD là công cụ GitOps cho Kubernetes.
- Nó theo dõi repo git chứa manifest hoặc Helm chart, rồi đồng bộ trạng thái đó xuống cluster.
- Điểm mạnh là có UI khá trực quan, dễ xem app nào đang `Synced`, `OutOfSync`, `Healthy` hay lỗi.

## Flux là gì

- Flux cũng là công cụ GitOps cho Kubernetes.
- Flux chạy theo mô hình controller trong cluster, tự đọc cấu hình từ git và áp vào hệ thống.
- Điểm mạnh là gọn, thiên về Kubernetes-native, tích hợp tốt nếu thích quản lý hoàn toàn bằng YAML/CLI.

## Giống nhau

- Đều dùng GitOps: git là source of truth.
- Đều tự sync thay đổi từ git xuống Kubernetes.
- Đều hỗ trợ Helm, Kustomize và nhiều kiểu manifest Kubernetes.
- Đều giúp audit, rollback và giảm việc deploy thủ công.

## So sánh nhanh

| Tiêu chí | Argo CD | Flux |
| --- | --- | --- |
| Cách dùng | Dễ tiếp cận hơn | Thiên về kỹ thuật hơn |
| Giao diện | Có UI mạnh, dễ quan sát | UI không phải điểm mạnh |
| Trải nghiệm vận hành | Dễ demo, dễ troubleshoot | Gọn, nhẹ, ít thành phần hơn |
| Mô hình quản lý | App-centric | Controller-centric |
| Phù hợp khi | Team cần nhìn trạng thái app rõ ràng | Team quen Kubernetes và muốn tối giản |

## Nên chọn khi nào

- Chọn Argo CD khi cần UI tốt, dễ onboarding team, dễ theo dõi từng application.
- Chọn Flux khi muốn mô hình gọn hơn, thuần Kubernetes hơn và ưu tiên quản lý bằng manifest.

## Kết luận ngắn

- Argo CD và Flux đều giải quyết cùng một bài toán GitOps.
- Argo CD mạnh về trải nghiệm quản trị và quan sát.
- Flux mạnh về sự tối giản và phong cách Kubernetes-native.
