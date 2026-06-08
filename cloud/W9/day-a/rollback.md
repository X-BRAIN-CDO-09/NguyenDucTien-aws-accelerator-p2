# Rollback

## Là gì

- `Rollback` là đưa hệ thống quay về trạng thái ổn định trước đó khi bản deploy mới bị lỗi.
- Mục tiêu là giảm downtime và giảm ảnh hưởng tới người dùng.

## Các cách rollback phổ biến

- Rollback image tag: đổi về version container cũ.
- Rollback manifest: trả manifest Kubernetes về bản cũ.
- Rollback bằng Helm: quay về revision trước.
- Rollback bằng GitOps: revert commit trong git để Argo CD hoặc Flux sync lại trạng thái cũ.

## Trong Kubernetes

- Với `Deployment`, có thể quay lại revision trước nếu rollout mới lỗi.
- Lệnh hay dùng là:

```bash
kubectl rollout undo deployment/<deployment-name>
```

- Nhưng rollback chỉ an toàn khi version cũ vẫn còn chạy tốt và tương thích với dữ liệu hiện tại.

## Trong GitOps

- Cách chuẩn thường là `revert commit`.
- Sau khi revert trong git, Argo CD hoặc Flux sẽ phát hiện thay đổi và đồng bộ cluster về trạng thái cũ.
- Cách này rõ ràng hơn vì lịch sử rollback được lưu luôn trong git.

## Ưu điểm của rollback qua GitOps

- Có lịch sử rõ ràng.
- Dễ audit.
- Trạng thái trong git và trong cluster đồng nhất.
- Giảm việc sửa tay trực tiếp trên cluster.

## So sánh `git revert` và `kubectl rollout undo`

| Cách | Ý nghĩa | Ưu điểm | Hạn chế |
| --- | --- | --- | --- |
| `git revert` | Revert commit trong repo rồi để Argo CD/Flux sync lại | Đúng tinh thần GitOps, có lịch sử rõ ràng, trạng thái không bị lệch | Chậm hơn một chút vì phải qua git và controller sync |
| `kubectl rollout undo` | Rollback trực tiếp `Deployment` trong cluster | Nhanh, hữu ích khi xử lý sự cố gấp | Nếu git vẫn đang giữ version lỗi thì Argo CD/Flux có thể sync ngược lại |

## Nên dùng cái nào

- Nếu hệ thống đang chạy GitOps, nên ưu tiên `git revert`.
- `kubectl rollout undo` chỉ nên xem là cách xử lý nhanh tạm thời khi incident đang diễn ra.
- Sau khi undo thủ công, vẫn phải sửa lại git nếu không trạng thái sẽ bị drift.

## Lưu ý

- Không phải lỗi nào cũng rollback được an toàn, nhất là khi có thay đổi database schema.
- Nếu rollback chỉ ở cluster nhưng không sửa lại git thì Argo CD/Flux có thể sync ngược lại bản lỗi.
- Nên chuẩn bị sẵn chiến lược rollback trước khi deploy production.
- Tốt nhất là deploy nhỏ, có health check và có thể quan sát nhanh sau release.

## Kết luận ngắn

- `Rollback` là phần bắt buộc trong quy trình deploy.
- Với GitOps, cách rollback tốt nhất thường là revert commit để hệ thống tự sync về trạng thái cũ.
