# Prometheus + Grafana + Loki

## 1. Vai trò từng thành phần

- `Prometheus`: scrape và lưu metrics dạng time-series
- `Grafana`: query data source và hiển thị dashboard
- `Loki`: lưu và query logs
- `Promtail`: đọc log từ node/container rồi đẩy vào Loki

## 2. Mindset

```text
Prometheus = metrics backend
Loki       = logs backend
Grafana    = visualization layer
Promtail   = log shipper
```

## 3. Data flow

### Metrics

```text
App / Node / K8s exporters
  -> Prometheus scrape
  -> Prometheus store metrics
  -> Grafana query Prometheus
```

### Logs

```text
Container stdout/stderr
  -> Promtail reads logs
  -> Loki stores logs
  -> Grafana queries Loki
```

## 4. Khi nào dùng gì

- Muốn biết `CPU`, `memory`, `requests`, `error rate` -> `Prometheus`
- Muốn biết `request cụ thể`, `stack trace`, `access log` -> `Loki`
- Muốn xem dashboard / Explore -> `Grafana`

## 5. Query examples

### PromQL

Pods by namespace:

```promql
count by (namespace) (kube_pod_info)
```

Node available memory:

```promql
node_memory_MemAvailable_bytes / 1024 / 1024 / 1024
```

Node CPU usage:

```promql
sum by (instance) (rate(node_cpu_seconds_total{mode!="idle"}[5m]))
```

### LogQL

Frontend logs:

```logql
{namespace="frontend"}
```

Frontend GET requests:

```logql
count_over_time({namespace="frontend"} |= "GET"[5m])
```

## 6. Practical takeaway

- metrics và logs là hai luồng khác nhau
- Prometheus không thay Loki
- Loki không thay Prometheus
- Grafana là nơi gom hai luồng đó lại để con người đọc dễ hơn
