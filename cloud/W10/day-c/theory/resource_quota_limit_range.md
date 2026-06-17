# ResourceQuota & LimitRange trong Kubernetes

## 1. ResourceQuota (Hạn ngạch tài nguyên)
* **Khái niệm**: Giới hạn **tổng lượng** tài nguyên tối đa mà tất cả các Pod trong một **Namespace** có thể tiêu thụ.
* **Mục đích**: Ngăn một Namespace sử dụng quá nhiều tài nguyên, làm ảnh hưởng đến các Namespace khác trên cùng cluster.
* **Ví dụ giới hạn**:
  * Tổng CPU (`limits.cpu`): tối đa 4 Cores.
  * Tổng RAM (`limits.memory`): tối đa 8 GiB.
  * Tổng số lượng Pods (`pods`): tối đa 10 Pods.

---

## 2. LimitRange (Phạm vi tài nguyên cá thể)
* **Khái niệm**: Thiết lập các quy tắc về lượng CPU/RAM **tối thiểu, tối đa** và **mặc định** cho **từng container/pod riêng lẻ** trong một Namespace.
* **Mục đích**:
  * Đảm bảo không có pod nào khai báo quá ít tài nguyên (dưới mức tối thiểu) hoặc quá nhiều (vượt mức tối đa).
  * Tự động áp dụng giá trị CPU/RAM mặc định (default requests/limits) nếu lập trình viên quên khai báo trong file Deployment.

---

## 3. So sánh nhanh

| Đặc điểm | ResourceQuota | LimitRange |
| :--- | :--- | :--- |
| **Phạm vi tác dụng** | **Toàn bộ** Namespace (tính tổng cộng) | **Từng Pod/Container** riêng lẻ |
| **Mục tiêu quản lý** | Ngăn Namespace chiếm dụng tài nguyên cụm | Đảm bảo tính nhất quán cấu hình container |
| **Hành vi mặc định** | Không tự gán giá trị mặc định | Có tự gán giá trị mặc định nếu thiếu |
