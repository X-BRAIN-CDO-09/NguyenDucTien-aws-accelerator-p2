# Abort Criteria

## 1. Abort criteria là gì

- `Abort criteria` là điều kiện để rollout dừng lại khi tín hiệu xấu xuất hiện.
- Đây là phần biến canary từ một kỹ thuật deploy thành một cơ chế giảm rủi ro thực sự.

## 2. Vì sao quan trọng

- Nếu rollout chỉ biết tăng traffic mà không biết lúc nào phải dừng, thì canary mất nhiều giá trị.
- Cần có logic rõ ràng cho 3 câu hỏi:
  - khi nào tiếp tục
  - khi nào pause thêm
  - khi nào abort

## 3. Các tín hiệu thường dùng

- success rate thấp hơn ngưỡng
- error rate vượt ngưỡng
- latency tăng quá mức cho phép
- burn rate xấu hơn mức chấp nhận được

## 4. Tư duy đúng

```text
abort không phải "thất bại của rollout"
abort là cơ chế bảo vệ hệ thống trước khi lỗi lan rộng
```

## 5. Practical takeaway

- Rollout tốt không phải là rollout luôn lên được 100%.
- Rollout tốt là rollout biết tự dừng đúng lúc khi version mới đang làm hệ thống xấu đi.
