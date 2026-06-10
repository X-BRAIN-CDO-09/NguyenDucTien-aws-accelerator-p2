# Canary Integration với Burn Rate

## 1. Vì sao nối canary với burn rate

- `Burn rate` cho biết tốc độ đang tiêu `error budget`.
- Khi gắn canary với burn rate, câu hỏi không còn là:

```text
error rate có cao không?
```

- Mà là:

```text
version mới có đang đốt error budget quá nhanh không?
```

## 2. Vì sao cách này mạnh hơn threshold thô

- raw error rate dễ quá nhạy hoặc quá ngây thơ
- burn rate gắn trực tiếp với `SLO`
- quyết định rollout vì thế gần với tác động vận hành thực hơn

## 3. Cách dùng trong rollout

- `AnalysisTemplate` query metric hoặc recording rule liên quan đến burn rate
- nếu burn rate vượt ngưỡng trong cửa sổ quan sát thì rollout abort
- nếu vẫn trong mức an toàn thì tiếp tục promote

## 4. Mindset

```text
Prometheus cung cấp tín hiệu
SLO định nghĩa ngưỡng có ý nghĩa
Argo Rollouts dùng tín hiệu đó để quyết định rollout
```

## 5. Practical takeaway

- Đây là chỗ observability và release engineering gặp nhau.
- `Canary + burn rate` giúp quyết định rollout dựa trên reliability, không chỉ dựa trên cảm giác hay threshold rời rạc.
