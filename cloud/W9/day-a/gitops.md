# GitOps

## Là gì

- `GitOps` là cách quản lý hạ tầng và ứng dụng bằng git.
- Repo git được xem là `source of truth`.
- Thay vì sửa trực tiếp trên cluster, ta sửa manifest trong git rồi để tool tự đồng bộ xuống hệ thống.

## Cách hoạt động

1. Developer sửa manifest, Helm values hoặc config trong git.
2. Tạo PR để review thay đổi.
3. Merge vào nhánh chính.
4. Argo CD hoặc Flux phát hiện thay đổi và sync xuống Kubernetes.

## Lợi ích

- Có lịch sử thay đổi rõ ràng.
- Dễ review, audit và rollback.
- Giảm thao tác thủ công trên cluster.
- Giúp trạng thái trong git và trạng thái hệ thống bám sát nhau.

## Liên hệ với CI/CD

- `CI` thường lo build, test, scan, push image.
- `CD` trong GitOps thường không deploy trực tiếp bằng `kubectl apply`.
- Thay vào đó, pipeline sẽ cập nhật manifest hoặc image tag trong git.
- Argo CD hoặc Flux sẽ làm phần đồng bộ xuống cluster.

## Công cụ hay dùng

- Argo CD
- Flux

## Kết luận ngắn

- GitOps là cách deploy theo hướng khai báo và lấy git làm trung tâm.
- Nó đặc biệt phù hợp với Kubernetes và giúp rollback an toàn hơn khi kết hợp với `git revert`.
