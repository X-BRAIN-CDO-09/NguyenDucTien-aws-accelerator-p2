# Progressive Delivery và Canary

## 1. Progressive Delivery là gì

- `Progressive Delivery` là cách phát hành version mới theo từng bước thay vì đẩy 100% traffic ngay lập tức.
- Mục tiêu là giảm `blast radius` nếu bản mới có vấn đề.
- Tư duy chính:
  - phát hành ít một
  - quan sát metric thật
  - chỉ tăng traffic khi tín hiệu ổn

## 2. Canary là gì

- `Canary` là strategy phổ biến nhất của `Progressive Delivery`.
- Thay vì chuyển toàn bộ user sang version mới, hệ thống chỉ cho một phần traffic đi qua bản mới trước.
- Nếu metric tốt thì tăng tiếp.
- Nếu metric xấu thì dừng, abort hoặc rollback.

## 3. Luồng suy nghĩ cơ bản

```text
release mới
  -> cho 5% / 10% traffic vào trước
  -> đo success rate / error rate / latency
  -> nếu ổn thì tăng dần
  -> nếu xấu thì dừng rollout
```

## 4. Vì sao cách này tốt hơn deploy all-at-once

- Giảm rủi ro khi version mới có bug.
- Dễ phát hiện vấn đề sớm hơn trước khi ảnh hưởng toàn bộ user.
- Phù hợp khi đã có observability đủ tốt để đánh giá rollout theo dữ liệu thật.

## 5. Mindset quan trọng

- `Canary` không chỉ là chia traffic.
- Giá trị thực của nó nằm ở việc:
  - gắn rollout với metric
  - có điều kiện promote rõ ràng
  - có điều kiện abort rõ ràng

## 6. One-line summary

```text
Progressive Delivery với Canary = phát hành version mới từng bước, quan sát metric, rồi mới quyết định đi tiếp hay dừng lại.
```
