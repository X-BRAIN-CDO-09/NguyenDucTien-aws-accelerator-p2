# W8 Project

Terraform lab này dựng một kiến trúc tối giản trên AWS để chạy app Node.js bên trong Kubernetes, cụ thể là `minikube` chạy trên một EC2. Traffic đi qua `ALB`, vào `NodePort` trên EC2, rồi được Kubernetes Service chuyển tiếp tới các pod của ứng dụng.

## Kiến trúc

```text
Internet
  -> ALB :80
  -> EC2 :30080
  -> Kubernetes Service (NodePort)
  -> Deployment (3 replicas)
```

Thành phần chính:

- `VPC` với 2 public subnet: 1 subnet cho EC2, 1 subnet bổ sung để ALB hoạt động multi-AZ.
- `EC2` Ubuntu chạy `docker`, `kubectl`, `minikube`.
- `ALB` public lắng nghe HTTP `:80` và forward vào `EC2:30080` theo NodePort của app.
- `Node.js app` chạy trong `Deployment` với `3 replicas` trong namespace `w8-demo`.

## Cấu trúc repo

```text
cloud/W8/W8-project/
├── README.md
├── evidence/
├── application/
└── infra/
    └── aws/
        ├── main.tf
        ├── providers.tf
        ├── versions.tf
        ├── variables.tf
        ├── terraform.tfvars
        ├── outputs.tf
        └── modules/
            ├── vpc/
            ├── ec2/
            └── alb/
```

## Provider Wiring

Lab này dùng nhiều provider trong cùng một cấu hình và chúng được wire với nhau như sau:

- `tls`: tạo SSH key pair bằng `tls_private_key`.
- `local`: ghi private key ra máy local bằng `local_sensitive_file`.
- `aws`: tạo `aws_key_pair` từ public key vừa sinh, sau đó gắn key pair này vào EC2 và dựng toàn bộ hạ tầng AWS.
- `cloudinit`: render `user_data` cho EC2 từ shell template, giúp bootstrap `minikube`, pull image từ ECR và apply workload Kubernetes.

Flow thực tế:

```text
tls_private_key
  -> local_sensitive_file
  -> aws_key_pair
  -> aws_instance

template shell script
  -> cloudinit_config
  -> aws_instance.user_data
```

Vì sao chọn cách này:

- Không cần tạo sẵn key pair thủ công trên AWS.
- `user_data` vẫn đọc dễ như shell script, nhưng được `cloudinit` render nhất quán.
- Toàn bộ lab có thể dựng lại từ đầu với cùng một Terraform config.

## Prerequisites

Trước khi chạy Terraform, cần có:

- AWS credentials hợp lệ trong shell hiện tại.
- `terraform >= 1.5`.
- Docker image của app đã được build và push lên ECR.
- `terraform.tfvars` đã trỏ đúng `app_image`.

Ví dụ build và push image:

```bash
cd cloud/W8/W8-project/application
docker buildx build --platform linux/amd64 -t 730335441285.dkr.ecr.ap-southeast-1.amazonaws.com/w8-project:latest .
docker push 730335441285.dkr.ecr.ap-southeast-1.amazonaws.com/w8-project:latest
```

## Chạy Lab

Từ root của project này, có thể dựng bằng một lệnh:

```bash
terraform -chdir=cloud/W8/W8-project/infra/aws init && terraform -chdir=cloud/W8/W8-project/infra/aws apply -auto-approve
```

Sau khi apply xong:

```bash
cd cloud/W8/W8-project/infra/aws
terraform output alb_dns_name
terraform output ssh_command
```

Mở URL ALB trên browser để kiểm tra app.

## Kiểm tra App đang chạy trong Kubernetes

SSH vào EC2 bằng output Terraform:

```bash
cd cloud/W8/W8-project/infra/aws
terraform output -raw ssh_command
```

Hoặc dùng trực tiếp:

```bash
ssh -i ./w8-minikube-lab-dev-id_ed25519 ubuntu@<ec2_public_ip>
```

Sau khi SSH vào EC2:

```bash
kubectl get ns
kubectl get deploy,pods,svc -n w8-demo
kubectl get svc w8-web -n w8-demo
```

Kết quả mong đợi:

- Có namespace `w8-demo`
- Có `Deployment/w8-web`
- Có `3` pod chạy
- Có `Service` kiểu `NodePort`

Điều này chứng minh app đang chạy trong K8s, không phải cài trực tiếp trên EC2.

## Deliverables

Khi nộp bài, repo nên có:

- Terraform code đầy đủ trong `cloud/W8/W8-project/infra/aws`
- `README.md` này
- Bằng chứng trong `cloud/W8/W8-project/evidence`
- Ảnh hoặc clip mở được app từ URL của ALB

## Evidence

Thư mục nộp bằng chứng nằm tại:

- [evidence](/Users/ductiennguyen/Documents/Project/xbrain/NguyenDucTien-aws-accelerator-p2/cloud/W8/W8-project/evidence)

Checklist chi tiết nằm trong:

- [evidence/evidence.md](/Users/ductiennguyen/Documents/Project/xbrain/NguyenDucTien-aws-accelerator-p2/cloud/W8/W8-project/evidence/evidence.md)

## Destroy

Sau khi demo xong, dọn sạch hạ tầng:

```bash
terraform -chdir=cloud/W8/W8-project/infra/aws destroy -auto-approve
```

## Acceptance Mapping

`1 lệnh từ repo sạch -> app chạy, URL ALB trả về trang app`

- Dùng `terraform -chdir=cloud/W8/W8-project/infra/aws init && terraform -chdir=cloud/W8/W8-project/infra/aws apply -auto-approve`

`App thực sự chạy trong K8s, không phải cài thẳng EC2`

- Bootstrap script tạo `minikube`, apply `Namespace`, `Deployment`, `Service`
- Kiểm tra bằng `kubectl get deploy,pods,svc -n w8-demo`

`Có >=2 provider được wire trong cùng cấu hình`

- Đang wire `aws`, `tls`, `local`, `cloudinit`

`Giải thích được vì sao chọn cách làm đó`

- Có ở mục `Provider Wiring`

`Dựng lại từ đầu cho kết quả như nhau`

- Cấu hình Terraform và bootstrap hiện tại là deterministic theo `terraform.tfvars` và image ECR đầu vào
