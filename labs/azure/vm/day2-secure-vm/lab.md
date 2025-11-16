
# Azure VM — Day 2: Hardened VM (Pattern)
- No inbound NSG rules (bastion/IAP-style access pattern)
- Managed Identity attached
- OS hardening pattern ready (cloud-init can be added)

```bash
az login
terraform init && terraform apply -auto-approve
```
Destroy: `terraform destroy -auto-approve`
