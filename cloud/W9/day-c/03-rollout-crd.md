# Rollout CRD

## 1. Rollout CRD là gì

- `Rollout` là custom resource của `Argo Rollouts`.
- Nó đóng vai trò tương tự `Deployment`, nhưng dành cho progressive delivery.
- Resource này mô tả:
  - replica
  - pod template
  - rollout strategy
  - các bước promote version mới

## 2. Khác gì với Deployment

- `Deployment` tập trung vào rolling update mặc định.
- `Rollout` cho phép mô tả logic rollout chi tiết hơn như:
  - `setWeight`
  - `pause`
  - `analysis`
  - `abort`

## 3. Tư duy cấu trúc

Ví dụ ý tưởng:

```yaml
strategy:
  canary:
    steps:
      - setWeight: 20
      - pause: { duration: 5m }
      - analysis:
          templates:
            - templateName: canary-success-rate
      - setWeight: 50
      - pause: { duration: 10m }
      - setWeight: 100
```

## 4. Ý nghĩa của từng bước

- `setWeight`: quyết định bao nhiêu traffic vào bản mới
- `pause`: dừng lại để quan sát hệ thống
- `analysis`: chạy kiểm tra metric trước khi được phép đi tiếp

## 5. Practical takeaway

- `Rollout CRD` là nơi encode toàn bộ chiến lược phát hành.
- Khi nhìn vào file này, mình biết release sẽ đi qua những decision point nào trước khi lên 100% traffic.
