# ✈️ United Airline — Volume 3 Lab Guide
# Cross-Cloud Network Architecture (AWS ↔ Azure ↔ GCP)
SecureTheCloud.dev — Labs Series

This lab implements the **multi-cloud private network fabric** connecting:
- AWS Transit Gateway (TGW)
- Azure Virtual WAN Hub (vWAN)
- GCP Cloud Router + HA VPN

All tunnels use **IPSec + BGP**, enabling dynamic, encrypted, fault-tolerant routing across clouds.

This lab transforms United Airline from a single-cloud environment into a **global, multi-cloud enterprise network**.

---

# 🧭 1. Lab Objectives

By the end of this lab you will deploy:

### ✔ AWS Components
- TGW
- TGW attachments
- TGW route tables
- Site-to-site VPN to Azure
- Site-to-site VPN to GCP

### ✔ Azure Components
- vWAN Hub
- VPN Gateway (active/active)
- BGP ASN configuration
- Connection to AWS
- Connection to GCP

### ✔ GCP Components
- HA VPN Gateway
- Cloud Router
- BGP sessions with AWS + Azure

### ✔ Cross-Cloud DNS
- Route53 Resolver forwarding → Azure
- Azure DNS Private Resolver → AWS
- GCP DNS Policy → AWS/Azure

### ✔ Logging
- Flow logs in all clouds
- BGP session logs
- VPN negotiation logs

This is the foundation for:
- Zero Trust app access (V4 Identity Federation)
- Multi-cloud KMS (V5)
- SIEM (V6)
- DR patterns (V7)

---

# 📂 2. Directory Structure

labs/volume3-cross-cloud-network/
│
└── terraform/
├── envs/
│ ├── aws-tgw/
│ ├── azure-vwan/
│ └── gcp-ha-vpn/
│
└── modules/
├── aws/tgw/
├── azure/vwan/
└── gcp/ha-vpn/

yaml
Copy code

---

# 🧱 3. Architecture Diagram

```mermaid
flowchart LR

subgraph AWS
  AWSTGW[AWS Transit Gateway]
  AWSVPC[Hub VPC]
  AWSVPC --> AWSTGW
end

subgraph AZURE
  VWAN[Azure vWAN Hub]
  VWGW[Azure VPN Gateway]
  VWGW --> VWAN
end

subgraph GCP
  GCPVPN[GCP HA VPN]
  GCPR[Cloud Router]
  GCPR --> GCPVPN
end

AWSTGW <-- IPsec+BGP --> VWGW
AWSTGW <-- IPsec+BGP --> GCPVPN
VWGW <-- IPsec+BGP --> GCPVPN
🛠️ 4. Prerequisites
From previous volumes:

Volume 1 AWS Hub deployed

Volume 2 Inspection VPC in place

Terraform v1.6+

Azure CLI logged in (az login)

gcloud CLI authenticated (gcloud auth login)

AWS CLI configured (aws configure)

🚀 5. Deployment Steps
🔵 PART A — AWS Transit Gateway
Step A1 — Navigate to AWS environment
bash
Copy code
cd labs/volume3-cross-cloud-network/terraform/envs/aws-tgw
terraform init
Step A2 — Apply TGW module
bash
Copy code
terraform apply
What this deploys:

Transit Gateway

TGW route table

Attach Hub VPC

Allocate TGW outside IPs for tunnels

Outputs:

aws_tgw_id

tunnel_outside_addresses[]

tgw_route_table_id

bgp_asn (default: 64512)

Copy these values for Azure and GCP sections.

🔵 PART B — Azure vWAN Hub + VPN
Step B1 — Navigate to Azure environment
bash
Copy code
cd ../azure-vwan
terraform init
Step B2 — Apply vWAN + VPN Gateway
bash
Copy code
terraform apply
What this deploys:

vWAN Hub

Azure VPN Gateway (active/active)

Azure BGP ASN (default: 65515)

Connections to AWS

Route propagation to Azure spokes

Outputs needed:

Azure VPN public IPs

Azure BGP peer IPs

Azure spoke address ranges

Copy outputs into AWS + GCP modules.

🟡 PART C — GCP Cloud Router + HA VPN
Step C1 — Navigate
bash
Copy code
cd ../gcp-ha-vpn
terraform init
Step C2 — Apply configuration
bash
Copy code
terraform apply
What this deploys:

HA VPN Gateway (2 tunnels)

Cloud Router

BGP ASN (default GCP: 64514)

BGP sessions to AWS + Azure

Outputs:

GCP VPN public IPs

GCP BGP tunnel interfaces

Record these for AWS tunnel configuration.

🔄 6. Cross-Cloud Integration Summary
You now have:

AWS TGW ↔ Azure vWAN (IPSec + BGP)
2 tunnels minimum

Redundant routing

Automatic failover

AWS TGW ↔ GCP Cloud Router
HA VPN

BGP dynamic routes

High availability

Azure vWAN ↔ GCP
(Optional in this lab, but scaffold included)

🔍 7. Validation Tests
Test 1 — BGP Routes Learned
AWS
bash
Copy code
aws ec2 get-transit-gateway-route-tables --transit-gateway-id <id>
Azure
bash
Copy code
az network vhub get-effective-routes --resource-group <RG> --name <vhub>
GCP
bash
Copy code
gcloud compute routers get-status <router-name> \
    --region=<region> --project=<project>
Expected:

AWS prefixes visible in Azure + GCP

Azure prefixes visible in AWS + GCP

GCP prefixes visible in AWS + Azure

Test 2 — Ping Across Clouds
Launch small instances/VMs in each cloud’s app subnet.

From AWS → Azure:

bash
Copy code
ping <azure-vm-private-ip>
From Azure → GCP:

bash
Copy code
ping <gcp-vm-private-ip>
From GCP → AWS:

bash
Copy code
ping <aws-ec2-private-ip>
All should respond.

Test 3 — No Internet Leakage
All clouds must still use AWS Network Firewall for egress:

Examples that must fail (blocked by Volume 2 rules):

nginx
Copy code
curl http://facebook.com
curl http://unknown-domain.xyz
Examples that must succeed (allowed):

nginx
Copy code
curl https://ubuntu.com
curl https://amazonaws.com
🛑 8. Troubleshooting
Issue	Cause	Fix
Tunnel down	Mismatched PSK or IKE policy	Check Terraform variables
BGP not established	ASN mismatch	Validate AWS 64512, Azure 65515, GCP 64514
Routes not showing	Propagation disabled	Enable RT propagation in TGW/vWAN
DNS not resolving	DNS not forwarded	Verify Route53 → Azure Private Resolver
Latency high	Wrong region pairing	Move vWAN hub closer to AWS region

📘 9. Binder: Errors & Fixes (Your Notes)
vbnet
Copy code
[2025-xx-xx] Azure tunnel stuck in "Connecting"
Fix: Set IPSec policy to match AWS Phase 1/2 parameters.

[2025-xx-xx] GCP learned routes but AWS didn't.
Fix: Added correct Cloud Router advertisement ranges.

[2025-xx-xx] DNS resolution failing from Azure.
Fix: Added Route53 Outbound Forwarding to Azure Private Resolver.
🧠 10. Summary
You have successfully deployed the United Airline multi-cloud backbone:

AWS TGW

Azure vWAN

GCP Cloud Router

Encrypted IPSec tunnels

Dynamic BGP routing

Cross-cloud DNS

Segmented security controls

Enterprise-grade logging

This enables the next volumes:

✔ Volume 4 — Identity Federation
(Entra ID → AWS/GCP, Crew Identity, App SSO)

✔ Volume 5 — Multi-Cloud KMS
(Coordinated key management across clouds)

✔ Volume 6 — SIEM + SOAR
(Log correlation across all clouds)

You now have a global airline network spanning AWS, Azure, and GCP.
