# Kubernetes Security Concepts

## 1. RBAC (Ủy quyền API)

- **Bản chất:** Trả lời bộ 3 câu hỏi: **Ai?** (`subjects`) → **Được làm gì?** (`verbs`) → **Ở đâu?** (`namespace` hoặc `cluster`).
- **Phân loại:**
  - `Role` + `RoleBinding`: Chỉ có tác dụng trong **1 Namespace** nhất định.
  - `ClusterRole` + `ClusterRoleBinding`: Có tác dụng trên **Toàn bộ Cluster** (áp dụng cho cả các tài nguyên hệ thống như Node, Namespace, PV).
- **Lệnh gác cổng (Kiểm tra quyền nhanh):**
  ```bash
  kubectl auth can-i <verb> <resource> --as=<user/sa> -n <namespace>
  ```

## 2. ServiceAccount (SA)

- **Bản chất:** Định danh (tài khoản) cấp cho **Máy móc/Ứng dụng/Bot** chạy trong Cluster để gọi API Server (K8s tự động mount Token JWT vào Pod dưới dạng file).
- **Production Practice (IRSA):** Gắn ServiceAccount với **AWS IAM Role** để Pod lấy Token tạm thời gọi dịch vụ AWS (S3, RDS...), loại bỏ hoàn toàn việc lưu Access Key tĩnh.

## 3. Admission Policy (Chốt chặn file YAML)

Nằm sau bước RBAC. RBAC check _người gõ lệnh_, Admission Policy check _nội dung file YAML_.

### A. ValidatingAdmissionPolicy (Native K8s 1.30+)

- **Đặc điểm:** Tích hợp sẵn trong API Server, siêu nhẹ, viết bằng ngôn ngữ **CEL**.
- **Kiến trúc:** Tách làm 2 file:
  - `Policy`: Chỉ để **Định nghĩa luật** (ví dụ: cấm chạy root). Cấp Cluster-scoped.
  - `Binding`: Để **Thực thi luật**. Quy định chế độ phạt (`Deny`, `Warn`, `Audit`) và ép xuống Namespace cụ thể.
- **Hạn chế:** Chỉ đọc được nội dung file YAML đang gửi lên, không check chéo được trạng thái toàn Cluster (ví dụ: check trùng domain Ingress).

### B. OPA / Gatekeeper (Third-party Webhook)

- **Đặc điểm:** Dùng ngôn ngữ **Rego** phức tạp nhưng cực mạnh. Check chéo được trạng thái Cluster nhờ cơ chế sync data cache riêng.
- **Kiến trúc:** Tách làm 2 file:
  - `ConstraintTemplate`: Khung chứa code logic Rego (Tự đúc ra một `kind` luật mới).
  - `Constraint`: Lời gọi hàm, truyền tham số YAML cụ thể để ép xuống tài nguyên/namespace. Giúp tái sử dụng code Rego.

## 4. Chế độ phạt: Audit vs Enforce

- **`enforce` (`Deny`):** Chặn đứng request lập tức nếu vi phạm. (Rủi ro cao gây downtime hệ thống cũ nếu rollout luật mới đột ngột).
- **`audit` (`Warn`):** Cho qua nhưng ghi log/cảnh báo. Dùng để rà soát lỗi của các đội phát triển trước khi chuyển sang cấm tiệt (`enforce`).
