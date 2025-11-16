# ✈️ United Airline — Volume 6 Lab Guide
# Multi-Cloud SIEM & SOAR (Microsoft Sentinel as Unified SOC)
SecureTheCloud.dev — Labs Series

This lab operationalizes the United Airline SOC by:
- Ingesting logs from AWS, Azure, and GCP into **Microsoft Sentinel**
- Deploying **analytics rules** (detections)
- Building **SOAR playbooks** (automatic response)
- Running **end-to-end detection tests**

This is where the United Airline architecture becomes **detectable, observable, and defensible**.

---

# 🧭 1) Lab Objectives

By the end of this lab, you will:

- Deploy a **Log Analytics Workspace** + **Sentinel**
- Integrate **AWS CloudTrail**, **GuardDuty**, **VPC Flow Logs**, **Route53 DNS logs**
- Integrate **Azure Activity Logs**, **Entra ID**, **NSG Flow Logs**, **Azure Firewall**
- Integrate **GCP Audit Logs** + **VPC Flow Logs** + **Cloud DNS**
- Build **KQL detection rules**
- Create **SOAR playbooks** that:
  - Block egress (AWS/Azure/GCP)
  - Disable identities (Entra, AWS SSO, GCP SA)
  - Quarantine compute instances
- Trigger controlled **incident simulations**

---

# 📂 2) Directory Structure

labs/volume6-siem-soar/
│
├─ README.md ← (this file)
└─ terraform/
└─ envs/
└── sentinel/
├── providers.tf
├── variables.tf
├── main.tf

yaml
Copy code

---

# 🔧 3) Sentinel Deployment (Terraform)

## Step 3.1 — Create directory
```bash
mkdir -p labs/volume6-siem-soar/terraform/envs/sentinel
cd labs/volume6-siem-soar/terraform/envs/sentinel
Step 3.2 — providers.tf
hcl
Copy code
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}
Step 3.3 — variables.tf
hcl
Copy code
variable "location"       { type = string, default = "eastus2" }
variable "resource_group" { type = string, default = "ua-soc-rg" }
variable "workspace_name" { type = string, default = "ua-soc-law" }
Step 3.4 — main.tf
hcl
Copy code
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law.id
}
Step 3.5 — Deploy
bash
Copy code
terraform init
terraform apply -auto-approve
🔌 4) Connect AWS Logs to Sentinel
4.1 — AWS CloudTrail → S3 → SQS
Ensure CloudTrail is enabled org-wide

Create S3 bucket for log delivery

Create SQS queue

Add S3 event notification → SQS

4.2 — Install AWS Solution Pack
Sentinel → Content Hub → Search “Amazon Web Services” → Install

4.3 — Configure the connector
Sentinel → Data Connectors → AWS CloudTrail

Provide S3 bucket

Provide SQS Arn

Create IAM role that Sentinel wizard requests

Trust Sentinel’s account

4.4 — Add GuardDuty
Install “AWS GuardDuty” connector
Provide the same S3/SQS pipeline or use direct API connector.

4.5 — Add AWS Network Firewall Logs (optional)
Export to CloudWatch Logs
Use the Azure Monitor Agent connector or S3 export.

🔷 5) Connect Azure Logs to Sentinel
5.1 — Activity Logs
Azure Portal:

Monitor → Activity Log → Diagnostic Settings

Send to Log Analytics Workspace

5.2 — Entra ID logs
Azure Portal:

Entra ID → Diagnostic Settings

Export:

Sign-in logs

Audit logs

Risky users

Send to Log Analytics Workspace

5.3 — NSG Flow Logs
Enable via Network Watcher → NSG Flow Logs → Log Analytics Workspace

5.4 — Azure Firewall logs
Diagnostic Settings → Send to LA Workspace

5.5 — Key Vault audit logs
🟡 6) Connect GCP Logs to Sentinel
6.1 — Create Pub/Sub topic + subscription
bash
Copy code
gcloud pubsub topics create ua-sentinel-topic
gcloud pubsub subscriptions create ua-sentinel-sub --topic ua-sentinel-topic
6.2 — Create Log Sink
Export Audit Logs, VPC Flow Logs, DNS Logs:

bash
Copy code
gcloud logging sinks create ua-sentinel-sink \
  pubsub.googleapis.com/projects/<PROJECT_ID>/topics/ua-sentinel-topic \
  --include-children
6.3 — Install GCP Solution Pack in Sentinel
6.4 — Configure connector
Provide Pub/Sub subscription details
Authorize Sentinel connector SA in GCP:

bash
Copy code
roles/pubsub.subscriber
roles/logging.viewer
🧪 7) Detection Rules (KQL)
Rule 1 — AWS Root Activity
kql
Copy code
AWSCloudTrail
| where UserIdentityType =~ "Root"
| where EventName !startswith "List" and EventName !startswith "Describe"
Rule 2 — KMS Decrypt Spike
kql
Copy code
AWSCloudTrail
| where EventSource == "kms.amazonaws.com"
| summarize c=count() by bin(TimeGenerated, 10m), UserIdentityArn
| where c > 20
Rule 3 — DNS Novelty + Firewall Deny
kql
Copy code
union isfuzzy=true
(Route53ResolverDNSLogs),
(AzureDiagnostics | where Category =~ "AzureFirewallDnsProxy")
| summarize uniq=dcount(QueryName) by bin(TimeGenerated, 1h), SrcIpAddr
| where uniq > 50
Rule 4 — GCP SCC Critical Findings
kql
Copy code
GCP_Alert
| where Severity in ("HIGH","CRITICAL")
Enable:

Schedule: every 5 minutes

Suppression: 5 minutes

Severity mapped to real risk

🤖 8) SOAR Playbooks (Automation)
Playbook 1 — Block Egress Everywhere
Actions:

AWS → network-firewall:UpdateRuleGroup

Azure → Update Azure Firewall rule

GCP → Add VPC Firewall egress deny rule

Log & notify SOC

Playbook 2 — Disable Identity
Entra ID: blockSignIn, revoke sessions

GCP: disable Service Account

AWS: remove Identity Center assignment

Playbook 3 — Quarantine Host
Tag VM/EC2 as quarantine=true

Apply deny-all SG/NSG

Remove public IP

Snapshot for forensic evidence

Connect them under:
Sentinel → Automation → Add Automation Rule → Attach playbook.

📝 9) Validation Tests
Test A — Root Console Login
From AWS:

bash
Copy code
aws cloudtrail lookup-events --lookup-attributes AttributeKey=Username,AttributeValue=root
Should raise a Critical incident.

Test B — Fake DNS Query
bash
Copy code
dig badrandomdomain123.com
Should:

appear in DNS logs

trigger rule

run SOAR playbook

Test C — GCP SCC
Enable a test SCC misconfiguration:

bash
Copy code
gcloud beta scc test enable --project=<PROJECT_ID>
Test D — KMS spike
Loop encrypt:

bash
Copy code
for i in {1..50}; do
  aws kms decrypt --key-id alias/ua-passenger-prod-key --ciphertext-blob ABCD...
done
🛑 10) Troubleshooting
Issue	Cause	Fix
AWS logs missing	Wrong SQS / IAM trust	Re-run connector wizard
GCP connector idle	Pub/Sub permissions	Add subscriber role
Azure logs missing	Missing Diagnostic Settings	Re-add to LAW
Playbook fails	Identity not authorized	Update managed identity roles

🧾 11) Binder — Errors & Fixes
vbnet
Copy code
[2025-xx-xx] AWS CloudTrail → Sentinel parser errors  
Fix: Enabled AWS solution pack; corrected S3 event prefix.

[2025-xx-xx] Pub/Sub subscriber permission denied.  
Fix: Bound roles/pubsub.subscriber to Sentinel SA.

[2025-xx-xx] Playbook blocked with 403.  
Fix: Gave Logic App MSI Azure Firewall Contributor + AWS NFW UpdateRuleGroup.
🧠 12) Summary
This lab completes the SOC brain and reflex system of United Airline:

Unified SIEM

Multi-cloud ingestion

KQL-powered detections

SOAR automation

End-to-end incident response flows

Your environment is now visible, detectable, and actively defended.
