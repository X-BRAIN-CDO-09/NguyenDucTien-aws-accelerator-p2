# Argo Rollouts

## 1. Argo Rollouts là gì

- `Argo Rollouts` là Kubernetes controller hỗ trợ các chiến lược deploy nâng cao.
- Hai strategy nổi bật:
  - `canary`
  - `blue-green`
- Nó được dùng khi `Deployment` mặc định không đủ cho nhu cầu rollout có kiểm soát.

## 2. Argo Rollouts giải quyết vấn đề gì

- `Deployment` chuẩn chủ yếu xử lý rolling update cơ bản.
- Nhưng khi cần:
  - tăng traffic theo nhiều bước
  - pause giữa các bước
  - chạy phân tích metric
  - tự abort nếu rollout xấu
  thì `Argo Rollouts` phù hợp hơn.

## 3. Điểm mạnh

- rollout theo step rõ ràng
- tích hợp analysis
- có thể dừng rollout tự động
- hỗ trợ progressive delivery tốt hơn mô hình deploy truyền thống

## 4. Mindset

```text
Deployment = rolling update cơ bản
Rollout    = rollout có strategy, analysis và decision points
```

## 5. Practical takeaway

- Nếu chỉ cần update tuần tự đơn giản thì `Deployment` là đủ.
- Nếu muốn deploy an toàn hơn theo kiểu canary có đo metric, `Argo Rollouts` là công cụ phù hợp.
