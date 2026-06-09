# OTel SDK + OTel Collector

## 1. OTel là gì

`OpenTelemetry` là chuẩn để instrument app và xuất telemetry:

- metrics
- logs
- traces

## 2. Hai khái niệm chính

### OTel SDK

SDK nằm trong app.

Nó dùng để:

- tạo span/trace
- ghi metric custom
- gắn attributes, resource metadata

### OTel Collector

Collector là thành phần trung gian.

Nó dùng để:

- nhận telemetry từ app
- xử lý, filter, batch
- export sang backend khác nhau

## 3. Flow tổng quát

```text
App
  -> OTel SDK
  -> OTel Collector
  -> Prometheus / Loki / tracing backend
```

## 4. Vì sao cần Collector

Nếu app gửi thẳng về backend:

- config bị phân tán
- đổi backend khó
- batching/retry khó kiểm soát

Collector giúp:

- tách concern khỏi app
- gom pipeline về một chỗ
- dễ route sang nhiều backend

## 5. Collector pipeline mindset

Collector thường có 3 phần:

- `receivers`
- `processors`
- `exporters`

Ví dụ:

```text
receiver: otlp
processor: batch
exporter: prometheusremotewrite / loki / otlp
```

## 6. Khi nào dùng OTel

- Khi muốn instrument app bài bản
- Khi muốn traces
- Khi muốn chuẩn hóa telemetry pipeline
- Khi muốn đổi backend mà app ít phải sửa

## 7. Practical takeaway

- `OTel SDK` = nằm trong app
- `OTel Collector` = gateway/router/processor cho telemetry
- OTel không thay Prometheus/Grafana/Loki
- OTel là cách app phát telemetry chuẩn hơn
