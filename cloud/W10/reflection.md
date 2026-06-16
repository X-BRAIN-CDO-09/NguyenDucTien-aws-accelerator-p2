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

---

## Day B: DevSecOps & Supply Chain Security

### 1. Quản lý Secrets tập trung với AWS Secrets Manager và ESO
- **Tập trung hóa Secrets:** Giải quyết triệt để bài toán rò rỉ thông tin bằng cách chuyển từ lưu trữ tĩnh (trong Git/manifests) sang quản lý tập trung trên AWS Secrets Manager.
- **Tự động hóa đồng bộ (ESO):** Sử dụng External Secrets Operator làm cầu nối tự động đồng bộ sang Kubernetes Native Secrets. Việc cấu hình `refreshInterval` giúp hệ thống tự động cập nhật khi Secrets được xoay vòng (rotated) trên AWS mà không cần can thiệp thủ công.

### 2. Rà quét hình ảnh (Trivy Scan) trong CI/CD
- **Chốt chặn đầu luồng:** Tích hợp Trivy trực tiếp vào pipeline CI/CD để phát hiện lỗ hổng OS (Alpine, Ubuntu...) và dependencies (npm, pip, maven...) trước khi đưa lên AWS ECR.
- **Fail-fast:** Thiết lập chặn (fail) pipeline nếu phát hiện CVE mức độ `CRITICAL` giúp lọc bỏ mã độc và thư viện lỗi thời ngay lập tức.

### 3. Ký số và xác thực nguồn gốc (Cosign)
- Đảm bảo tính toàn vẹn (Integrity) của container image thông qua chữ ký số.
  - **Key-based:** Tạo cặp khóa `cosign.key` / `cosign.pub` để thực thi ký và xác minh thủ công.
  - **Keyless OIDC (Khuyên dùng):** Sử dụng OIDC token cấp từ nhà cung cấp CI (như GitHub) và ghi log xác minh lên Rekor public log, loại bỏ hoàn toàn việc quản lý và lưu trữ khóa Private.

### 4. Admission Webhook để xác thực chữ ký (Kyverno)
- Tận dụng sức mạnh của **Kyverno** hoạt động như một Admission Controller để tự động kiểm chứng chữ ký của mọi image được deploy lên cụm.
- Bất kỳ Pod nào sử dụng image chưa được ký số hợp lệ hoặc bị can thiệp trái phép đều bị chặn đứng (`Block/Deny`) ngay tại cửa API Server.

### 5. Quản lý chính sách ngoại lệ (Exception Handling)
- Trong thực tế, cần linh hoạt xử lý các lỗ hổng chưa có bản vá từ upstream hoặc false positive:
  - **Trivy:** Sử dụng `.trivyignore` để bỏ qua có kiểm soát các mã CVE cụ thể.
  - **Kyverno:** Khai báo tài nguyên `PolicyException` nhằm áp dụng ngoại lệ kiểm thử cho các namespace/services cụ thể (ví dụ: các hệ thống legacy) mà không làm suy yếu chính sách chung của toàn cụm.

### 6. Rút ra bài học
- Bảo mật chuỗi cung ứng là một luồng khép kín (End-to-End): Không chỉ đơn thuần là phân quyền (RBAC) hay quét image, mà là sự kết hợp chặt chẽ từ khâu Code -> Build (Trivy Scan) -> Sign (Cosign) -> Admission Control (Kyverno) -> Runtime (ESO). Chỉ một mắt xích yếu cũng có thể phá hỏng toàn bộ hệ thống.