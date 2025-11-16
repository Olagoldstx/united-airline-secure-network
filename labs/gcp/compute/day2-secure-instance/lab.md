
# GCP Compute — Day 2: Hardened Instance
- No public IP
- OS Login enabled
- Egress-only firewall (HTTPS)

```bash
gcloud auth application-default login
terraform init && terraform apply -auto-approve
```
Destroy: `terraform destroy -auto-approve`
