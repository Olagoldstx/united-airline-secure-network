# ✈️ United Airline — Volume 1 Lab Guide
# Zero-to-Hardened AWS Hub (Day-1)
SecureTheCloud.dev — Labs Series

This lab deploys the **United Airline AWS Hub**, the security anchor for the entire multi-cloud architecture.

It is designed to:
- Build a **private-only VPC**
- Enforce **zero-trust routing**
- Enable **Flow Logs** and DNS controls
- Prepare for **centralized egress firewall** (Volume 2)
- Deliver **enterprise-grade Terraform structure**

---

# 🧭 1. Lab Overview

This is the foundational lab in the United Airline series.  
You will deploy:

- Hub VPC (10.10.0.0/20)
- 3 tiers of **private** subnets:
  - `app`
  - `data`
  - `mgmt`
- Per-tier route tables (default-deny)
- VPC Flow Logs (ALL → CloudWatch Logs)
- Route53 Resolver endpoints  
- IAM roles for logging
- Outputs for connecting Azure, GCP, and future TGW

This is a **zero-internet, zero-exposure, fully logged** environment.

---

# 🛠️ 2. Prerequisites

### CLI Tools
- Terraform ≥ 1.6
- AWS CLI v2
- Make (optional but recommended)

### AWS IAM Permissions
You need one of:

- AdministratorAccess  
**or**
- The ability to create:
  - VPCs
  - Subnets
  - Route tables
  - CloudWatch log groups
  - IAM roles & policies
  - Route53 Resolver endpoints

### AWS Account Info (Your Setup)
Account ID: 764265373335
IAM user ARN: arn:aws:iam::764265373335:user/cloudlab-user

yaml
Copy code

---

# 📂 3. Lab Folder Structure

labs/volume1-aws-hub/
└── README.md ← (this file)
terraform/
└── envs/
└── aws-hub/ ← your day-1 deployment environment

yaml
Copy code

---

# 🧱 4. Architecture Diagram (Day-1 Hub)

```mermaid
flowchart TD
  A[Private Subnets<br>app/data/mgmt] --> RT[Route Tables<br>Default-Deny]
  RT --> NF[Future: Network Firewall<br>(Volume 2)]
  A --> DNS[Route53 Resolver<br>Inbound/Outbound]
  A --> LOGS[VPC Flow Logs<br>CloudWatch]

  subgraph Hub VPC
    A
    RT
    DNS
    LOGS
  end

  INTERNET((No IGW<br>No Public Subnets))
🚀 5. Step-by-Step Deployment
Step 1 — Navigate to the environment
bash
Copy code
cd labs/volume1-aws-hub/terraform/envs/aws-hub
Step 2 — Initialize Terraform
bash
Copy code
terraform init
Step 3 — Validate configuration
bash
Copy code
terraform validate
Step 4 — Review the plan
bash
Copy code
terraform plan
Step 5 — Apply
bash
Copy code
terraform apply
📤 6. Terraform Outputs You Should See
After a successful deploy, note these outputs:

hub_vpc_id

private_subnet_ids

resolver_inbound_ip_addresses

resolver_outbound_ip_addresses

nat_gateway_ids (placeholder or empty — by design)

Save these in your binder.

🔍 7. Validation Checklist
Networking
 No IGW exists

 No public subnets exist

 All workloads launched in this VPC have no public IP

 No 0.0.0.0/0 routes exist

 Subnets are private & AZ-distributed

Logging
 CloudWatch Log Group created

 VPC Flow Logs are enabled (ALL)

 IAM role created for logging

DNS
 Resolver inbound endpoint created

 Resolver outbound endpoint created

Everything above must be true before we can proceed to Volume 2.

🧪 8. Optional: Deploy a Test EC2 (No Internet Expected)
Expected behavior:

Instance launches

Cannot access internet (correct)

DNS works inside VPC (correct)

Logs appear in CloudWatch (correct)

Use this to verify:

bash
Copy code
ping 8.8.8.8      # should fail
nslookup amazon.com   # should resolve
🛑 9. Troubleshooting (Real Binder Notes)
Issue	Cause	Fix
Flow logs role error	IAM role not propagated	Wait 10–30s and re-apply
Resolver endpoint subnet errors	Wrong subnet tier	Assign resolver to mgmt or app tier
Default route accidentally added	Manual edit or resource drift	Terraform apply to revert
EC2 has internet	IGW exists from a previous project	Delete the IGW or use a new VPC

Add your own errors here — this is how you build your binder.

🧩 10. How This Lab Fits the Bigger Picture
Volume 1 prepares all future volumes:

Volume 2
AWS Network Firewall + GWLB (centralized egress)

Volume 3
Azure vWAN + GCP Cloud Router → attach into this hub

Volume 4
Identity federation (Entra → AWS/GCP)

Volume 5
Multi-cloud KMS & encryption pipeline

Volume 6
SIEM + SOAR with CloudTrail + FlowLogs + GCP SCC + Azure Sentinel

Volume 7
Multi-region DR & service failover

Volume 8
AI analytics pipeline for flight telemetry, cargo, emissions

This hub is the foundation for everything.

📝 11. Binder: Errors & Fixes
Record your actual mistakes during the lab:

yaml
Copy code
[2025-xx-xx] Terraform error: missing IAM permission...
Fix: Added iam:CreateRole and iam:AttachRolePolicy via AWS console.

[2025-xx-xx] Resolver outbound failed: subnet does not support endpoints.
Fix: Reassigned to mgmt-tier subnet + terraform apply.
🧠 12. Summary
You completed:

Private-only AWS Hub

Zero-trust network foundation

Logging and DNS visibility

Terraform modular structure

Validated that no outbound or inbound internet exists

Your United Airline network has officially begun.

Proceed to:

👉 Volume 2 — Centralized Egress & Inspection (AWS Network Firewall + GWLB)

---

# 🔬 United Airline — Volume X Lab
## <Title of Lab>

---

## 🎯 Objectives
- Clear  
- Actionable  
- What student will learn  

---

## 🗺️ Architecture View

```mermaid
<INSERT LAB DIAGRAM HERE>
📦 Prerequisites
Terraform version

Cloud credentials

Required tools

🚀 Steps
1. Initialize
csharp
Copy code
terraform init
2. Plan
nginx
Copy code
terraform plan
3. Apply
nginx
Copy code
terraform apply
🔍 Validation Checklist
 VPC created

 Subnets correct

 Firewalls working

 Logs flowing

🧪 Troubleshooting
Issue	Cause	Fix
403	Missing IAM permission	Add IAM policy
Fail to deploy	Wrong region	Update vars

📝 Binder — Errors & Fixes (Fill During Real Deployment)
csharp
Copy code
[YYYY-MM-DD] Error encountered...
Fix applied...
