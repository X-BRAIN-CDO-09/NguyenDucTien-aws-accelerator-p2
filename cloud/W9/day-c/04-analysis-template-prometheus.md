# AnalysisTemplate với Prometheus

## 1. AnalysisTemplate là gì

- `AnalysisTemplate` là resource mô tả cách đánh giá chất lượng của rollout bằng metric.
- Nó cho phép rollout không chỉ đi theo thời gian, mà đi theo dữ liệu thực tế.

## 2. Vì sao cần AnalysisTemplate

- Nếu chỉ tăng traffic theo lịch cố định thì rollout vẫn khá mù.
- `AnalysisTemplate` thêm lớp kiểm tra:
  - metric có đang tốt không
  - version mới có đang ổn không
  - có đủ điều kiện để promote tiếp không

## 3. Tích hợp với Prometheus

- Một pattern rất quan trọng là lấy metric từ `Prometheus`.
- Các query thường gặp:
  - success rate
  - error rate
  - latency p95 / p99
  - request volume

## 4. Ví dụ ý tưởng

```yaml
metrics:
  - name: success-rate
    interval: 1m
    count: 5
    successCondition: result[0] >= 0.99
    provider:
      prometheus:
        query: |
          sum(rate(http_requests_total{job="app",status!~"5.."}[5m]))
          /
          sum(rate(http_requests_total{job="app"}[5m]))
```

## 5. Cách đọc ví dụ

- mỗi `1m` chạy một lần
- chạy tổng cộng `5` lần
- nếu kết quả thấp hơn `0.99` thì không đạt

## 6. Practical takeaway

- `AnalysisTemplate` là cầu nối giữa rollout và observability.
- Không có metric tốt thì canary chỉ là traffic shifting, chưa phải release an toàn theo nghĩa đầy đủ.
