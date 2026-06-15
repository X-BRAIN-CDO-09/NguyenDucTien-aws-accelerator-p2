# W10 Reflection

## Day A: Kubernetes Security & Admission Control

### 1. RBAC và ServiceAccount
- Nắm vững khái niệm cốt lõi của RBAC trong K8s: quản lý quyền dựa trên câu hỏi "Ai" (`subjects`), "Được làm gì" (`verbs`), "Ở đâu" (`namespace/cluster`).
- Phân biệt rõ `Role/RoleBinding` (giới hạn trong 1 Namespace) và `ClusterRole/ClusterRoleBinding` (áp dụng toàn Cluster).
- Hiểu được vai trò của ServiceAccount như một định danh cho ứng dụng/bot giao tiếp với API Server. Đặc biệt hữu ích khi kết hợp với AWS IAM Role (IRSA) để Pod lấy Token tạm thời truy cập các dịch vụ AWS một cách an toàn mà không cần lưu tĩnh Access Key.
- Biết cách sử dụng `kubectl auth can-i` để kiểm tra nhanh quyền hạn của các User/ServiceAccount trên Cluster.

### 2. Admission Policy: ValidatingAdmissionPolicy và OPA/Gatekeeper
- Hiểu được vị trí của Admission Policy: hoạt động như chốt chặn sau bước RBAC, chuyên kiểm tra nội dung file YAML gửi lên API Server.
- **ValidatingAdmissionPolicy**: Là tính năng native của K8s (từ 1.30), siêu nhẹ, dùng ngôn ngữ CEL. Hạn chế là chỉ validate trên scope file được gửi lên, không kiểm tra chéo được trạng thái của toàn cluster.
- **OPA / Gatekeeper**: Sử dụng webhook với ngôn ngữ Rego mạnh mẽ. Ưu điểm lớn là có thể kiểm tra chéo trạng thái Cluster. Kiến trúc tách biệt rõ ràng giữa khung logic (`ConstraintTemplate`) và thực thi luật (`Constraint`).

### 3. Các chế độ thực thi (Audit vs Enforce)
- Nắm được chiến lược triển khai policy an toàn:
  - Bắt đầu với **`audit` (Warn)**: cho phép tài nguyên được tạo ra nhưng ghi log/cảnh báo, giúp rà soát và cho các team thời gian sửa đổi mà không làm gián đoạn hệ thống.
  - Chuyển sang **`enforce` (Deny)**: chặn đứng các request vi phạm luật ngay tại cửa API Server, đảm bảo tính tuân thủ bảo mật tuyệt đối cho Cluster.

### 4. Điều rút ra
- Bảo mật trong K8s là một quá trình nhiều lớp: Bắt đầu từ việc kiểm soát quyền truy cập API (RBAC) đến việc giám sát và can thiệp sâu vào cấu hình tài nguyên (Admission Policy).
- Nên áp dụng phương pháp tiếp cận mềm dẻo (Audit) trước khi siết chặt (Enforce) để tránh downtime không đáng có trên môi trường Production.