# ✈️ United Airline — Volume 2 Lab Guide
# Centralized Egress & Deep Packet Inspection
# AWS Network Firewall + Gateway Load Balancer (GWLB)
SecureTheCloud.dev — Labs Series

This lab builds the **Centralized Egress Inspection Architecture** for the United Airline multi-cloud environment.

You will deploy:
- A dedicated **Inspection VPC**
- **AWS Network Firewall** (NFW)
- **Gateway Load Balancer (GWLB)**
- **GWLB Endpoints** in the Hub VPC
- **Suricata rule groups**
- **Egress route tables** forcing ALL subnets → GWLB endpoint → NFW
- Full **firewall logging** (flow + alert)
- **FQDN-based allow/deny lists**

This is the core egress enforcement layer for United Airline.

---

# 🧭 1. Lab Objectives

By the end of this lab, you will have:

- A **central inspection VPC** connected to the Hub VPC
- A **fully transparent** layer-7 firewall inline
- Traffic from ALL hub subnets forced through **GWLB → NFW**
- DNS filtering
- Deep packet inspection (DPI)
- Suricata rules blocking malicious patterns
- Egress allow/deny controls
- Logging into CloudWatch Logs

This lab upgrades security posture from hardened → enterprise-class.

---

# 🛠️ 2. Prerequisites

From Volume 1:
- **Hub VPC deployed**  
- Flow logs and DNS resolver configured  
- No IGW or public subnets  
- Zero-trust routing in place  

### Local tools
- Terraform ≥ 1.6
- AWS CLI v2

### IAM Permissions
You need permissions to create:
- VPCs
- Subnets
- NAT (optional)
- Network Firewall
- GWLB + endpoints
- IAM roles
- CloudWatch Log Groups
- Route tables + associations

---

# 📂 3. Directory Structure

labs/volume2-egress-inspection/
└── README.md ← (this file)

terraform/
└── envs/
└── aws-egress-inspection/
├── main.tf
├── variables.tf
├── providers.tf
└── gwlb-firewall.tf

scss
Copy code

---

# 🧱 4. Architecture Diagram

```mermaid
flowchart LR
  APP[App Subnets] --> RT1[Updated Route Tables]
  DATA[Data Subnets] --> RT2[Updated Route Tables]
  MGMT[Mgmt Subnets] --> RT3[Updated Route Tables]

  RT1 --> EP1[GWLB Endpoint]
  RT2 --> EP2[GWLB Endpoint]
  RT3 --> EP3[GWLB Endpoint]

  subgraph Hub VPC
    APP
    DATA
    MGMT
    EP1
    EP2
    EP3
  end

  EP1 --> GWLB[Gateway Load Balancer]
  GWLB --> NFW[AWS Network Firewall<br>Deep Packet Inspection]

  subgraph Inspection VPC
    GWLB
    NFW
  end

  NFW --> NAT[NAT or IGW (controlled)]
  NAT --> INTERNET((Internet))

  NFW --> DNSF[DNS Filtering / Suricata Rules]
  DNSF --> LOGS[Firewall Logs → CloudWatch]
```
---

🚀 5. Deployment Steps
✅ Step 1 — Navigate to the lab environment
bash
Copy code
cd labs/volume2-egress-inspection/terraform/envs/aws-egress-inspection
✅ Step 2 — Initialize Terraform
bash
Copy code
terraform init
✅ Step 3 — Validate
bash
Copy code
terraform validate
✅ Step 4 — Plan
bash
Copy code
terraform plan
✅ Step 5 — Apply
bash
Copy code
terraform apply
Terraform will build:

Inspection VPC

Firewall subnets in 2 AZs

Gateway Load Balancer

Network Firewall endpoints

Firewall policy + rule groups

GWLB endpoints inside the Hub VPC

Updated hub route tables

🔧 6. Configuration Details
6.1 Firewall Rule Groups Created
The Terraform config deploys:

✔ Stateful Rule Group (Suricata)
Block outbound SSH

Block SMTP

Block IRC

Block Tor nodes

Detect DNS tunneling

Detect unusual TLS patterns

✔ Domain Allow-List Rule Group
Allowed (example):

amazonaws.com

ubuntu.com

docker.com

microsoft.com

gstatic.com

Everything else = denied.

✔ Domain Block-List Rule Group
Malware C2 domains

Crypto-mining pools

DNS tunneling patterns

🌐 7. Updated Routing Model
After deployment, each Hub subnet should route like this:

Copy code
0.0.0.0/0 → GWLB Endpoint → NFW → NAT → Internet
No subnet will ever route directly to the internet.

🧪 8. Validation Tests
🔍 Test 1 — No direct internet access
SSH into a test instance:

bash
Copy code
curl http://example.com
Expected:

csharp
Copy code
Blocked or timed out
🔍 Test 2 — Allowed domains work
bash
Copy code
curl https://ubuntu.com
curl https://amazonaws.com
Expected:

Copy code
HTTP/2 200 OK
🔍 Test 3 — Blocked domains
bash
Copy code
curl http://malicious-domain.test
Expected:

nginx
Copy code
Connection timed out OR blocked
🔍 Test 4 — DNS filtering
bash
Copy code
nslookup bad-domain.test
Expected:

nginx
Copy code
REFUSED
🔍 Test 5 — Suricata alert logs
Check CloudWatch:

swift
Copy code
/aws/network-firewall/stateful-engine-logs/...
You should see:

Block events

Alert signatures

DNS tunneling attempts

🛑 9. Troubleshooting
Issue	Cause	Fix
NFW refuses traffic	Wrong rule group order	Ensure stateful rules before stateless
GWLB endpoint errors	Missing AZ mapping	Ensure endpoints in ALL hub subnets
No internet after firewall	NAT not connected	Attach NAT in inspection VPC
DNS still leaking	Hub RT using default resolver	Force Route53 outbound endpoint

📘 10. Binder: Errors & Fixes (Fill This During Lab)
Example:

vbnet
Copy code
[2025-xx-xx] Endpoint service not accepting traffic.
Fix: Added missing GWLB endpoint policy.

[2025-xx-xx] DNS resolution bypassing firewall.
Fix: Updated Hub RT to forward DNS to outbound resolver.
Keep real errors — your binder becomes more valuable.

🧠 11. Summary
In Volume 2 you deployed:

Inspection VPC

Network Firewall

Gateway Load Balancer

GWLB endpoints

Custom firewall rule groups

DNS filtering

Deep packet inspection

Strict egress Zero Trust

Full logging pipeline

This transforms your AWS Hub into a true enterprise network, ready for:

Volume 3 (Cross-Cloud Networking into Azure & GCP)

Volume 4 (Identity Federation)

Volume 6 (SIEM & SOAR)

You now control EVERY PACKET leaving the United Airline cloud.
