# Lab Day C - Platform Integration, Secrets & Security

- **Repository:** https://github.com/nguyenductien-qnm/argocd-observability-lab (Sử dụng lại repo từ W9)

---

## 1. Đồng bộ & Xoay vòng Secret (External Secrets Operator - ESO)

- **GitOps hóa ESO:** Triển khai cài đặt `External Secrets Operator` lên K3s thông qua ArgoCD App-of-Apps.
- **Cấu hình ClusterSecretStore:** Kết nối an toàn đến AWS Secrets Manager (`ap-southeast-1`).
- **Đồng bộ tự động:** Cấu hình `ExternalSecret` đồng bộ key `DATABASE_PASSWORD` từ `demo-w10` về K8s Secret (`api-secret`) mỗi 30 giây.
- **Cơ chế Hot-Reload (Không downtime):** Mount `api-secret` làm Read-only Volume tại `/etc/secrets/` trong Pod API (thay cho env tĩnh), giúp cập nhật secret tức thì mà không cần restart container.

---

## 2. Tăng cường Bảo mật Cụm (Kyverno Admission Control)

- **Enforce Policy:** Kích hoạt Kyverno `ClusterPolicy` (`verify-image-signature`) ở chế độ `Enforce`.
- **Xác thực chữ ký số:** Chặn triển khai các Pod có image chưa được ký (`no signatures found`). Chỉ chấp nhận các container image đã ký số hợp lệ bằng Cosign thông qua GitHub Actions CI.
