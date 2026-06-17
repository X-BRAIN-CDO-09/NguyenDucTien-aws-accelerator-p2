# AWS Cost Anomaly Detection (Phát hiện chi phí bất thường)

## 1. Khái niệm
* **AWS Cost Anomaly Detection**: Dịch vụ quản lý chi phí miễn phí của AWS, sử dụng công nghệ Machine Learning để tự động theo dõi lịch sử chi tiêu, phát hiện ra các khoản phát sinh bất thường (anomalies) và gửi cảnh báo ngay lập tức.
* **Mục tiêu**: Ngăn ngừa thảm họa hóa đơn (billing shock) do quên xóa tài nguyên, cấu hình sai hoặc hệ thống bị tấn công.

---

## 2. Cách thức hoạt động
1. **Lập mô hình hành vi tiêu dùng (Model)**: AWS phân tích chi phí lịch sử của bạn để hiểu chu kỳ sử dụng bình thường.
2. **Phát hiện bất thường (Detect)**: Khi có chi phí đột biến vượt ngưỡng dự báo thông thường, AWS sẽ đánh dấu là một sự cố bất thường.
3. **Cảnh báo (Alert)**: Gửi thông báo chi tiết qua Email hoặc tích hợp phòng chat Slack/Teams thông qua dịch vụ **Amazon SNS (Simple Notification Service)**.

---

## 3. Các loại giám sát (Monitors)
Bạn có thể cấu hình giám sát theo 4 tiêu chí chính:
* **AWS Services**: Phát hiện chi phí bất thường của một dịch vụ cụ thể (ví dụ: bỗng nhiên chi phí EC2 tăng đột biến).
* **Linked Accounts**: Giám sát biến động chi phí trên tài khoản thành viên (nếu dùng AWS Organizations).
* **Cost Categories**: Theo dõi theo các nhóm chi phí tự phân loại.
* **Cost Allocation Tags**: Theo dõi chi phí của các dự án/môi trường cụ thể thông qua Tag (ví dụ: tag `Environment=prod`).
