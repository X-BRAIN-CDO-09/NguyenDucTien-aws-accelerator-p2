# Chaos Testing (Kiểm thử hỗn loạn) trong Kubernetes

## 1. Khái niệm
* **Chaos Testing**: Phương pháp chủ động đưa các sự cố/lỗi giả lập (như sập node, mất kết nối mạng, kill pod đột ngột, tăng latency) vào hệ thống đang chạy để kiểm tra khả năng phục hồi và tính ổn định.
* **Triết lý**: Hệ thống phân tán chắc chắn sẽ lỗi. Mục tiêu không phải là ngăn chặn lỗi tuyệt đối, mà là đảm bảo hệ thống tự phục hồi tốt mà không làm gián đoạn người dùng.

---

## 2. Mục tiêu kiểm thử trong Kubernetes
* **Kiểm tra Self-Healing**: Khi Pod bị kill đột ngột, ReplicaSet/Deployment có tự tạo lại Pod mới để thay thế ngay lập tức không?
* **Kiểm tra Trạng thái High Availability (HA)**: Khi sập 1 node hoặc 1 Pod, các Pod còn lại có gánh được tải (traffic) không?
* **Kiểm tra Khả năng Rollback (Canary)**: Khi bản cập nhật mới (Canary) bị tăng tỉ lệ lỗi (injected errors), hệ thống có tự động rollback về bản Stable không?
* **Kiểm tra Hệ thống Cảnh báo (Alerting)**: Hệ thống giám sát (Prometheus/Grafana) có phát hiện lỗi và gửi cảnh báo (Slack, Email) kịp thời không?

---

## 3. Cách thực hiện cơ bản
1. **Thủ công (CLI)**:
   * Giả lập sập pod: `kubectl delete pod <pod-name> -n <namespace>`
   * Giả lập quá tải CPU/RAM: Chạy các script stress-test bên trong container.
2. **Tự động (Tools)**: Sử dụng các công cụ chuyên dụng như **Chaos Mesh**, **LitmusChaos**, hoặc **Gremlin** để lập lịch sự cố ngẫu nhiên.
