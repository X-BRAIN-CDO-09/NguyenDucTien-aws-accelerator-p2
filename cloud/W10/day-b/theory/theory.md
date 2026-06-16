# AWS Security & DevSecOps Integration (Day 10B)

Tài liệu này tổng hợp lý thuyết về việc xây dựng một luồng **Supply Chain Security** (Bảo mật chuỗi cung ứng phần mềm) hoàn chỉnh, kết hợp giữa AWS và Kubernetes.

---

## 1. Quản lý Secrets với AWS Secrets Manager & External Secrets Operator (ESO)

### Giới thiệu các thành phần

- **AWS Secrets Manager:** Dịch vụ lưu trữ bảo mật tập trung (passwords, API keys, database credentials...) do AWS quản lý. Giúp loại bỏ việc hardcode thông tin nhạy cảm vào mã nguồn hoặc lưu trữ thủ công trong `ConfigMap`/`Secret` dạng clear-text.
- **External Secrets Operator (ESO):** Một Kubernetes Operator chạy trong cụm, có vai trò tự động hóa việc đồng bộ hóa (sync) dữ liệu từ các dịch vụ quản lý secret bên ngoài (như AWS Secrets Manager, HashiCorp Vault, GCP Secret Manager) vào trong các `Secret` bản địa của Kubernetes.

```text
[ AWS Secrets Manager ]
         │
         │  (ESO tự động đồng bộ hóa)
         ▼
[ Kubernetes Secret ] ───► [ Pods/Applications ]
```

### Secrets Rotation (Xoay vòng thông tin bảo mật)

- **Cơ chế:** Tự động thay đổi thông tin đăng nhập định kỳ (ví dụ: thay đổi mật khẩu Database sau mỗi 30 ngày) để giảm thiểu rủi ro khi bị lộ.
- **Đồng bộ phía K8s:** ESO sử dụng tham số `refreshInterval` để định kỳ kéo (pull) dữ liệu mới nhất từ AWS Secrets Manager về Kubernetes, đảm bảo ứng dụng luôn sử dụng secret mới nhất mà không cần khởi động lại thủ công.

---

## 2. Rà quét lỗ hổng bảo mật với Trivy Image Scan

**Trivy** là một công cụ quét bảo mật (vulnerability scanner) mã nguồn mở mạnh mẽ, dễ tích hợp vào luồng CI/CD để phát hiện lỗi bảo mật trước khi Docker image được đẩy lên registry (như AWS ECR).

```text
[ Build Image ] ──► [ Trivy Scan ] ──► Có CVE Nghiêm Trọng (Critical)?
                                             ├──► Có ──► [ FAIL Pipeline ❌ ]
                                             └──► Không ─► [ Push ECR & Ký Image ✅ ]
```

### Các lớp kiểm tra của Trivy:

1.  **OS Packages:** Quét các thư viện hệ thống của hệ điều hành nền (Alpine, Ubuntu, Debian...).
2.  **Language Dependencies:** Quét các thư viện ứng dụng (Packages từ npm, pip, maven, go module, gem...).
3.  **Misconfigurations:** Quét lỗi cấu hình sai trong file Dockerfile, Kubernetes manifests, hoặc Terraform templates.

---

## 3. Ký và xác thực Image với Cosign (Sigstore)

Việc ký image giúp đảm bảo tính toàn vẹn của phần mềm (ngăn chặn tấn công Man-in-the-Middle hoặc thay đổi image bất hợp pháp).

### Cách 1: Xác thực dựa trên Key-pair (Key-based)

Sử dụng cặp khóa public/private được tạo thủ công để ký và xác minh.

```bash
# 1. Tạo cặp khóa cosign.key (private) và cosign.pub (public)
cosign generate-key-pair

# 2. Ký Docker image bằng private key
cosign sign --key cosign.key <registry>/<image>:<tag>

# 3. Xác minh chữ ký của image bằng public key
cosign verify --key cosign.pub <registry>/<image>:<tag>
```

### Cách 2: Xác thực không dùng Key (Keyless OIDC)

Không cần quản lý và lưu trữ cặp khóa thủ công. Thay vào đó, sử dụng định danh (Identity) của môi trường CI/CD (như GitHub Actions).

```text
[ GitHub Actions ] ──► Nhận OIDC Token từ GitHub (xác thực danh tính)
         │
         ▼
[ Cosign Sign ] ────► Ký Image + Ghi chứng thực lên Rekor Transparency Log
         │
         ▼
[ Verify Image ] ───► Xác minh dựa trên OIDC Issuer (github.com) + Rekor Log
```

- **Ưu điểm:** Loại bỏ hoàn toàn rủi ro lộ khóa Private Key.
- **Nhược điểm:** Yêu cầu kết nối Internet và phụ thuộc vào Rekor log public.

---

## 4. Kiểm soát triển khai với Admission Webhook (Kyverno)

**Admission Webhook** là một cơ chế của Kubernetes API Server giúp can thiệp, kiểm tra hoặc chỉnh sửa các yêu cầu (requests) tạo/sửa đổi tài nguyên trước khi chúng được lưu vào `etcd`.

```text
[ kubectl apply ] ──► [ API Server ]
                           │
                           ├──► (Gọi Webhook) ──► [ Kyverno Policy Engine ]
                           │                             │
                           │                      [ Kiểm tra Chữ ký ]
                           │                             ├──► Hợp lệ ──► ALLOW ✅
                           │                             └──► Vô hiệu ─► BLOCK ❌
                           ▼
                     [ Đã triển khai Pod ]
```

### Phân loại Webhook:

- **MutatingWebhook:** Được gọi trước, cho phép chỉnh sửa cấu hình (ví dụ: tự động chèn sidecar container, chuyển image tag dạng `:latest` sang dạng ID SHA256 digest cố định).
- **ValidatingWebhook:** Được gọi sau, chỉ thực hiện kiểm tra và đưa ra quyết định cho phép (`Allow`) hoặc từ chối (`Deny`) triển khai tài nguyên mà không làm thay đổi nội dung của nó.

---

## 5. Cơ chế Ngoại lệ (Exception Policy) cho CVE và Image

Trong thực tế, có những lỗ hổng bảo mật (CVE) chưa có bản vá (unfixed) từ phía upstream hoặc không ảnh hưởng trực tiếp đến môi trường chạy. Việc chặn hoàn toàn sẽ gây gián đoạn vận hành (block deploy). Vì vậy cần thiết lập các chính sách ngoại lệ hợp lệ.

### Whitelist cấu hình với Trivy (`.trivyignore`)

Bạn có thể bỏ qua các mã lỗi CVE cụ thể bằng cách khai báo chúng trong file cấu hình `.trivyignore` ở thư mục gốc của dự án:

```text
# .trivyignore
# Lỗi chưa có bản vá chính thức từ nhà phát triển, không ảnh hưởng trực tiếp
CVE-2023-1234
# Lỗi cảnh báo nhầm (False positive) đối với thư viện ABC
CVE-2023-5678
```

### Whitelist triển khai với Kyverno `PolicyException`

Kyverno cung cấp một Custom Resource Definition (CRD) tên là `PolicyException` giúp miễn trừ một số Pod hoặc Namespace cụ thể khỏi chính sách chặn nghiêm ngặt.

```yaml
apiVersion: kyverno.io/v2beta1
kind: PolicyException
metadata:
  name: allow-legacy-image
  namespace: legacy-system
spec:
  exceptions:
    - policyName: check-image-signature
      ruleNames:
        - verify-signature
  match:
    any:
      - resources:
          kinds:
            - Pod
          namespaces:
            - legacy-system # Chỉ áp dụng ngoại lệ cho namespace này
```

---

## 6. Luồng bảo mật đầu-cuối (End-to-End DevSecOps Flow)

Mô hình luồng bảo mật hoàn chỉnh từ Code đến khi ứng dụng chạy trên Cluster:

```text
[ Dev push code ]
        │
        ▼
[ GitHub Actions ] ──► [ Build Image ] ──► [ Trivy Scan ] (Phát hiện CVE Critical ❌ -> Hủy)
        │
        ▼
[ Push Image to ECR ]
        │
        ▼
[ Cosign Sign Image ] (Ký nhận thực bằng khóa hoặc OIDC)
        │
        ▼
[ Deploy Manifests ] ──► [ Kubernetes API Server ]
                                  │
                                  ▼
                        [ Kyverno Webhook ] (Xác thực chữ ký Image ❌ -> Block)
                                  │
                                  ▼
                            [ Pod RUNS ]
                                  │
                                  ▼
                        [ ESO Sync Secrets ] ◄── (Đồng bộ định kỳ từ AWS Secrets Manager)
```
