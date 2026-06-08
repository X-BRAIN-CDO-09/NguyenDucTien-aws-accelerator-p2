# Sync Wave

## Là gì

- `Sync wave` là cơ chế của Argo CD để kiểm soát thứ tự apply resource.
- Mặc định Argo CD sync nhiều resource cùng lúc, nhưng có trường hợp phải tạo theo thứ tự.
- Ví dụ: cần tạo `Namespace`, `CRD`, `ConfigMap` hoặc `Secret` trước khi tạo `Deployment`.

## Cách dùng

- Dùng annotation:

```yaml
metadata:
  annotations:
    argocd.argoproj.io/sync-wave: "0"
```

- Resource có `sync-wave` nhỏ hơn sẽ được apply trước.
- Có thể dùng số âm như `-1`, `-2` để chạy sớm hơn nữa.

## Ví dụ thứ tự

- `-1`: `Namespace`, `CRD`
- `0`: `ConfigMap`, `Secret`, `Service`
- `1`: `Deployment`
- `2`: `Ingress`

## Khi nào cần dùng

- Khi resource có phụ thuộc lẫn nhau.
- Khi dùng `App of Apps` và muốn app nào lên trước app nào.
- Khi triển khai operator hoặc custom resource cần CRD có sẵn trước.

## Lưu ý

- `Sync wave` chỉ giải quyết thứ tự sync, không thay thế hoàn toàn health check.
- Nếu cấu hình quá nhiều wave thì sẽ khó đọc và khó maintain.
- Chỉ nên dùng khi thật sự có dependency rõ ràng.

## Kết luận ngắn

- `Sync wave` giúp Argo CD deploy resource theo đúng thứ tự mong muốn.
- Nó hữu ích khi có dependency giữa các resource hoặc giữa các application.
