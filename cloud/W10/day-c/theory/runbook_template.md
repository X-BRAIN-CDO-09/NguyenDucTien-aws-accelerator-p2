# Runbook Template (Tài liệu hướng dẫn xử lý sự cố)

## 1. Khái niệm
* **Runbook**: Tài liệu hướng dẫn chi tiết từng bước (step-by-step) dành cho SRE/DevOps để ứng phó và giải quyết nhanh các sự cố kỹ thuật cụ thể trong môi trường Production.
* **Mục đích**: Giảm thiểu thời gian phục hồi hệ thống (MTTR - Mean Time To Resolution) và giảm tải áp lực tâm lý cho người trực sự cố (On-call engineer).

---

## 2. Tiêu chuẩn cấu trúc một Runbook hiệu quả

### Phần A: Tổng quan sự cố (Overview)
* **Mô tả**: Tên sự cố (ví dụ: *High Memory Usage on API Service*).
* **Mức độ nghiêm trọng**: P1 (Khẩn cấp), P2 (Cao), P3 (Trung bình).
* **Ảnh hưởng (Impact)**: Ứng dụng bị chậm, phản hồi HTTP 500, lỗi người dùng không đăng nhập được.

### Phần B: Dấu hiệu nhận biết (Triggering Alert)
* Tên cảnh báo từ Prometheus/Grafana (ví dụ: `ApiMemoryUsageHigh`).
* Link dẫn tới Grafana Dashboard kiểm tra trực tiếp.

### Phần C: Các bước xác minh (Verification Steps)
Các câu lệnh dòng lệnh dùng để kiểm chứng nhanh trạng thái thực tế:
```bash
# Kiểm tra tài nguyên RAM thực tế của các Pod trong namespace
kubectl top pods -n <namespace>

# Xem log lỗi của Pod
kubectl logs <pod-name> -n <namespace> --tail=100
```

### Phần D: Các bước khắc phục tạm thời (Mitigation Steps)
Các hành động xử lý nhanh để hệ thống hoạt động trở lại:
* **Phương án A**: Thực hiện Rollout restart: `kubectl rollout restart deployment <deploy-name> -n <namespace>`.
* **Phương án B**: Tăng tạm thời số lượng Pod (Scale up): `kubectl scale deployment <deploy-name> --replicas=5 -n <namespace>`.

### Phần E: Khắc phục triệt để & Root Cause Analysis (RCA)
* Link ticket ghi nhận lỗi phần mềm cần dev fix cứng.
* Tài liệu phân tích nguyên nhân gốc rễ sau sự cố.
