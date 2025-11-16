
# AWS EC2 — Day 2: Hardened Instance
- IMDSv2 required
- No inbound security group rules (SSM-only)
- Amazon Linux 2023, t3.micro

```bash
terraform init && terraform apply -auto-approve
```
Destroy: `terraform destroy -auto-approve`
