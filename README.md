# terraform-aws-dynamic

> 변동성이 큰 인프라

- eks
- ec2

## 파일구조

```bash
.
├── README.md
├── backend.tf
├── main.tf
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── eks
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── outputs.tf
├── template
│   ├── bastion_host.sh
│   └── user_data.sh
├── variables.tf
└── versions.tf
```