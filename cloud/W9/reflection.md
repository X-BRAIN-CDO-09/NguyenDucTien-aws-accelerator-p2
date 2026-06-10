# W9 Reflection

## Day A: GitOps và CI/CD

### 1. GitHub Actions và quy trình CI/CD

- Học được rằng GitHub Actions là công cụ tự động hóa workflow trong repo, có thể dùng cho `build`, `test`, `lint`, `plan` và `deploy`.
- Nắm lại các thành phần chính như `on`, `jobs`, `steps`, `uses`, `run`, `runs-on`, `env`, `secrets`.
- Điểm đáng chú ý nhất hôm nay là pattern `plan-on-PR + apply-on-merge`:
  - Khi có `pull_request` thì chỉ nên chạy kiểm tra và `plan`.
  - Chỉ khi merge vào `main` mới thực hiện `apply` hoặc deploy thật.
- Cách làm này an toàn hơn vì có bước review trước khi thay đổi đi vào môi trường thật.

### 2. GitOps

- Hiểu rõ hơn rằng GitOps lấy git làm `source of truth`.
- Thay vì sửa trực tiếp trên cluster, thay đổi được thực hiện qua manifest hoặc cấu hình trong git.
- Sau khi merge, tool như Argo CD hoặc Flux sẽ tự đồng bộ trạng thái từ git xuống Kubernetes.
- Cách này giúp dễ audit, dễ review và hạn chế drift giữa code với hệ thống thực tế.

### 3. Argo CD và Flux

- Cả Argo CD và Flux đều giải quyết bài toán GitOps trên Kubernetes.
- Argo CD nổi bật ở UI và khả năng quan sát trạng thái application.
- Flux thiên về sự gọn nhẹ và phong cách Kubernetes-native hơn.
- Rút ra là việc chọn công cụ phụ thuộc khá nhiều vào cách team vận hành:
  - Nếu cần UI tốt và dễ onboarding thì nghiêng về Argo CD.
  - Nếu muốn tối giản và quản lý thuần YAML/CLI thì Flux phù hợp hơn.

### 4. App of Apps và Sync Wave

- Học được pattern `App of Apps` trong Argo CD để quản lý nhiều application thông qua một application cha.
- Pattern này hữu ích khi cần bootstrap cluster hoặc quản lý nhiều thành phần theo cách tập trung hơn.
- Học thêm về `sync wave` để kiểm soát thứ tự sync resource.
- Đây là điểm quan trọng vì trong thực tế nhiều resource có dependency với nhau, ví dụ `CRD` cần có trước khi tạo custom resource, hoặc `ConfigMap/Secret` cần có trước khi tạo `Deployment`.

### 5. Rollback

- Hôm nay rõ hơn về hai hướng rollback:
  - `git revert`: revert thay đổi trong repo rồi để Argo CD/Flux sync lại.
  - `kubectl rollout undo`: rollback trực tiếp `Deployment` trong cluster.
- Rút ra rằng nếu đang theo GitOps thì `git revert` là cách chuẩn hơn vì giữ được lịch sử và tránh lệch trạng thái giữa git với cluster.
- `kubectl rollout undo` vẫn hữu ích khi xử lý sự cố nhanh, nhưng nếu không cập nhật lại git thì thay đổi có thể bị sync ngược trở lại.

### 6. Điều rút ra

- CI/CD và GitOps kết hợp với nhau khá tự nhiên:
  - CI lo kiểm tra, build, scan, tạo artifact hoặc image.
  - GitOps lo đồng bộ trạng thái đã được duyệt xuống cluster.
- Điểm quan trọng nhất tôi rút ra hôm nay là nên tránh deploy thủ công trực tiếp vào cluster nếu đã chọn mô hình GitOps.
- Ngoài ra, rollback không nên chỉ nghĩ là “quay lại bản cũ”, mà phải nghĩ đến việc giữ cho trạng thái trong git và trong hệ thống luôn nhất quán.

# Day B - Observability

## Topics covered

1. `Prometheus + Grafana + Loki + Promtail`
2. `OTel SDK + OTel Collector`
3. `SLI / SLO`
4. `Availability + Latency SLO methodology`
5. `Multi-window burn rate alert`

## High-level picture

```text
App
  -> metrics
  -> logs
  -> traces

metrics -> Prometheus -> Grafana
logs    -> Promtail/Collector -> Loki -> Grafana
traces  -> OTel SDK -> OTel Collector -> tracing backend
```

## Learning goal

Hiểu được:

- observability stack vận hành ra sao
- app instrument bằng OTel như thế nào
- SLI / SLO được định nghĩa thế nào
- burn rate alert dùng để phát hiện đang đốt error budget nhanh hay chậm

# Day C - Progressive Delivery (Canary)

## Topics covered

1. `Argo Rollouts`
2. `Rollout CRD`
3. `Canary strategy`
4. `AnalysisTemplate với Prometheus query`
5. `Abort criteria`
6. `Integration với burn rate`

## High-level picture

```text
new version
  -> rollout theo từng bước
  -> đo metric từ Prometheus
  -> nếu ổn thì tăng traffic
  -> nếu xấu thì abort / rollback
```

## What I learned

- `Canary` không chỉ là chia traffic, mà là phát hành có kiểm soát dựa trên tín hiệu quan sát được.
- `Argo Rollouts` cung cấp rollout strategy nâng cao hơn `Deployment`, đặc biệt hữu ích khi cần pause, analysis và abort tự động.
- `Rollout CRD` là trung tâm của cách làm này vì nó mô tả từng bước promote version mới.
- `AnalysisTemplate` giúp gắn rollout với metric thật từ `Prometheus` như success rate, error rate hoặc latency.
- `Abort criteria` là phần quyết định giá trị thực tế của canary, vì rollout phải biết khi nào dừng thay vì chỉ tăng traffic theo lịch cố định.
- Điểm quan trọng nhất hôm nay là có thể nối canary với `burn rate`, tức là dùng logic SLO/error budget để quyết định có nên tiếp tục rollout hay không.

## Takeaway

- `Progressive Delivery` hợp lý nhất khi đứng cùng `observability`.
- `AnalysisTemplate + Prometheus + burn rate` là cách biến canary từ một kỹ thuật deploy thành một cơ chế giảm rủi ro thực sự.
