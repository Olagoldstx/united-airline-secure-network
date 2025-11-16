
# AWS IAM — Day 1: Least Privilege & IAM Roles
Region: `us-east-1`

```bash
aws configure sso   # or: aws configure
export AWS_PROFILE=default
terraform init && terraform apply -auto-approve
```
Validate: IAM → Roles → `stc-ec2-role`  
Destroy: `terraform destroy -auto-approve`
