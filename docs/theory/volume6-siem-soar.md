✈️ United Airline — Volume 6
Multi‑Cloud SIEM & SOAR (Detect, Investigate, Respond)

SecureTheCloud.dev — Binder Series

🧭 1) Purpose of Volume 6

Volumes 1–5 hardened the network, identity, and data layers.
Volume 6 elevates United Airline to an operational security posture: continuous detection, investigation, and automated response across AWS, Azure, and GCP.

Goals

Centralize logs & signals from all clouds.

Normalize data for correlation and threat detections.

Map detections to MITRE ATT&CK.

Automate containment & remediation (SOAR).

Establish SLA metrics (MTTD, MTTR) and governance.

Identity is the new perimeter; telemetry is your radar; SOAR is your autopilot.

🛫 2) Analogy: Airline Operations Control Center (OCC)

Pilots / aircraft → apps & workloads

Flight plans → change events & API calls

ATC radar → logs & network telemetry

Dispatch → SIEM correlation + threat intel

Irregular Operations (IROPs) → incidents

OCC playbooks → SOAR automation

As the OCC orchestrates real‑world disruptions, SIEM/SOAR orchestrates cyber disruptions.

🧱 3) Telemetry You Must Ingest
Cloud	Category	Examples (United Airline)
AWS	Control plane	CloudTrail, Organizations, Config
	Network	VPC Flow Logs, Route 53 Resolver query logs, Network Firewall logs, ALB/ELB, WAF
	Identity & Threat	GuardDuty, IAM Identity Center audit, KMS usage
Azure	Control plane	Activity Logs, Resource Manager
	Network	NSG Flow Logs, Azure Firewall logs, WAF
	Identity & Threat	Entra ID sign‑in/risk, Defender for Cloud, Key Vault audit
GCP	Control plane	Cloud Audit Logs (Admin/Data/Access)
	Network	VPC Flow Logs, Cloud DNS logs, Cloud Armor, IDS
	Identity & Threat	Security Command Center (findings), KMS usage

Data gravity decision: pick a primary pane of glass.
United Airline default: Microsoft Sentinel (Azure) as the unified SIEM, because Entra ID is our single IdP. (Alternative patterns: Chronicle or Splunk—supported in Appendix.)

🌐 4) Reference Architecture (Sentinel as “pane of glass”)
flowchart LR
  subgraph AWS
    A1[CloudTrail]-->A4
    A2[GuardDuty]-->A4
    A3[VPC Flow / DNS / NFW]-->A4[S3/SQS/Kinesis]
  end
  subgraph Azure
    Z1[Activity/Entra/Defender]-->SEN
    Z2[NSG/Firewall/WAF]-->SEN
    Z3[Key Vault Logs]-->SEN
    SEN[Microsoft Sentinel (Log Analytics)]
  end
  subgraph GCP
    G1[Audit Logs]-->G2[Pub/Sub]
    G3[Flow/DNS/Armor]-->G2
  end
  A4--Connectors-->SEN
  G2--Connector-->SEN
  SEN-->SOAR[Logic Apps Playbooks]
  SOAR--API Actions-->AWSAPI[AWS API]
  SOAR--API Actions-->AZAPI[Azure API]
  SOAR--API Actions-->GCPAPI[GCP API]


Normalization: Prefer OCSF/ECS compatible schemas where possible for cross‑provider queries.

🛡️ 5) Core Detections (United Airline “Top 12”)
#	Use Case	Key Signals	ATT&CK
1	Root / Break‑glass use	AWS CloudTrail UserIdentity.type == Root	TA0001
2	Impossible travel (IdP)	Entra sign‑ins from distant geos in short time	TA0001
3	Mass KMS decrypt anomaly	KMS Decrypt/GenerateDataKey spikes	TA0009
4	Outbound to new/malicious domain	NFW/Firewall deny + DNS query novelty	TA0010
5	GuardDuty High/Critical	GuardDuty findings	varies
6	SCC High/Critical	GCP SCC findings	varies
7	Priv escalation attempt	IAM/Role updates + subsequent privilege	TA0004
8	API abuse	Burst Create*/Put* across accounts/projects	TA0003
9	Key Vault/Secret anomalous access	KV audit + UserAgent anomalies	TA0006
10	Suspicious VPC egress bypass	Route change → new egress path	TA0011
11	Disabled logging / tampering	DeleteTrail/StopLogging events	TA0005
12	Container escape/K8s abuse	EKS/AKS/GKE audit anomalies	TA0005/TA0008

Each detection produces an incident with owner, SLA, runbook link, and SOAR playbook.

🤖 6) SOAR Playbooks (Automated Response Library)

Containment

Block egress: Update AWS Network Firewall rule group, Azure Firewall, GCP VPC FW.

Disable identity: Block sign‑in for Entra user / revoke sessions; suspend GCP SA; revoke AWS SSO session (via IdP).

Isolate workload: Quarantine SG/NSG; detach public IP; stop instance; lock service account.

Eradication / Recovery

Rotate secrets/keys (KMS alias roll).

Re‑enable logging; restore trail/diagnostic settings.

Ticketing: create P1; notify owners; capture “Errors & Fixes”.

Forensics

Tag & snapshot instance disks; export logs to evidence store.

💾 7) Retention & Cost Strategy

Hot analytics: 30–60 days in SIEM.

Cold storage: raw logs to S3 / Blob / GCS for 12–365 months.

Filter high‑cardinality logs (e.g., VPC Flow) with sampling or DCR rules; keep DNS + Firewall complete.

📏 8) Governance & SLAs

Track:

MTTD (detect)

MTTR (respond)

% high‑sev incidents with playbooks

Detection coverage vs. ATT&CK

False positive rate

Monthly review: detection tuning + cost optimization.

🧪 9) Example Analytics (KQL ideas for Sentinel)

Names vary per connector; adapt to actual table names in your workspace.

A. AWS root activity

AWSCloudTrail
| where UserIdentityType =~ "Root"
| where EventName !startswith "List" and EventName !startswith "Describe"
| project TimeGenerated, AWSAccountId, EventName, SourceIpAddress, UserAgent


B. KMS decrypt spikes

AWSCloudTrail
| where EventSource == "kms.amazonaws.com" and EventName in ("Decrypt","GenerateDataKey","GenerateDataKeyWithoutPlaintext")
| summarize cnt=count() by bin(TimeGenerated, 15m), UserIdentityArn
| where cnt > 20


C. DNS novelty + firewall deny

union isfuzzy=true
(Route53ResolverDNSLogs | project TimeGenerated, QueryName, SrcIpAddr=SrcIpAddr),
(AzureDiagnostics | where Category == "AzureFirewallDnsProxy" | project TimeGenerated, QueryName=msg_s, SrcIpAddr)
| summarize dcount(QueryName) by bin(TimeGenerated, 1h), SrcIpAddr
| where dcount_QueryName > 50


D. Impossible travel (IdP)

SigninLogs
| extend Country = tostring(LocationDetails.countryOrRegion)
| summarize First=min(TimeGenerated), Last=max(TimeGenerated), count() by UserPrincipalName, Country
| where count_ > 1
| // join with IP/Geo to detect impossible travel patterns

🧩 10) How V6 Fits Forward

V7 (Resilience & DR): incident simulations, region failover drills, SIEM continuity.

V8 (AI & Sustainability): anomaly detection on ops/fuel data; ML‑powered detections.

📝 11) Binder — Errors & Fixes (fill during rollout)

Connector auth failures → verify role trust / keys.

Duplicate/looped ingestion → dedupe at source or DCR.

High cost from VPC Flow Logs → sample, aggregate at source, keep DNS full‑fidelity.

🧠 12) Summary

You now have the SOC brain for United Airline:

One pane of glass for AWS, Azure, GCP

Normalized analytics + ATT&CK‑mapped detections

SOAR playbooks to contain threats across clouds

Retention + governance to sustain the program

✅ Next

Create the hands‑on lab:

nano labs/volume6-siem-soar/README.md

📄 Paste this next:
nano labs/volume6-siem-soar/README.md

✈️ United Airline — Volume 6 Lab Guide
Multi‑Cloud SIEM & SOAR (Microsoft Sentinel as Pane of Glass)

SecureTheCloud.dev — Labs Series

This lab onboards multi‑cloud telemetry into Microsoft Sentinel, builds analytics rules, and wires SOAR playbooks for automated containment across AWS, Azure, and GCP.

🧭 1) Lab Objectives

Create Log Analytics Workspace + Sentinel.

Connect data from AWS (CloudTrail, GuardDuty) and GCP (Audit Logs).

Ingest key Azure streams (Activity/Entra/Firewall/Key Vault).

Build scheduled analytics rules (KQL).

Create SOAR playbooks (Logic Apps) to block egress / disable identities.

Validate with test events.

📂 2) Directory Layout
labs/volume6-siem-soar/
├─ README.md
└─ terraform/
   └─ envs/
      └─ sentinel/
          ├─ providers.tf
          ├─ variables.tf
          └─ main.tf

🛠️ 3) Prerequisites

Azure subscription with Contributor/Owner; ability to deploy Log Analytics and Sentinel.

Admin access in AWS & GCP to create data export roles/queues/topics.

CLI: Azure CLI, AWS CLI, gcloud.

Terraform ≥ 1.6 (optional but included here).

🔧 4) Deploy Sentinel (Terraform)

labs/volume6-siem-soar/terraform/envs/sentinel/providers.tf

terraform {
  required_version = ">= 1.6.0"
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">=3.100.0" } }
}
provider "azurerm" { features {} }


variables.tf

variable "location"       { type = string, default = "eastus2" }
variable "resource_group" { type = string, default = "ua-soc-rg" }
variable "workspace_name" { type = string, default = "ua-soc-law" }


main.tf

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Onboard Sentinel on the workspace
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "sentinel" {
  workspace_id = azurerm_log_analytics_workspace.law.id
}


Apply:

cd labs/volume6-siem-soar/terraform/envs/sentinel
terraform init && terraform apply -auto-approve

🔌 5) Connectors (High‑level steps)

Exact UI names can change; follow the Microsoft Sentinel → Content hub / Data connectors guidance.

A) AWS CloudTrail & GuardDuty

In AWS, create/confirm CloudTrail writing to S3.

Create SQS queue and configure S3 Event Notification (new objects).

In Sentinel, install the Amazon Web Services solution and open AWS CloudTrail connector.

Provide the S3 bucket and SQS queue details; complete role/policy steps shown in the connector wizard.

Repeat for GuardDuty connector (either via S3/SQS or direct API, per wizard instructions).

B) GCP Audit Logs

Create a Pub/Sub topic + subscription.

Create a Log Sink exporting Audit Logs (Admin/Data/Access) to this topic.

In Sentinel, install the Google Cloud Platform solution and open the connector.

Provide Pub/Sub subscription details and follow the wizard steps to grant permissions.

C) Azure Signals

Enable Microsoft Sentinel solutions for:

Azure Activity

Entra ID (Sign‑in, Audit)

NSG Flow Logs (via Network Watcher)

Azure Firewall logs

Key Vault diagnostics

Use Diagnostic Settings to route each to the Log Analytics workspace.

Keep DNS & Firewall logs at full fidelity; sample VPC/NSG flow logs if costs rise.

🔎 6) Create Analytics Rules (KQL)

In Sentinel → Analytics → Create → Scheduled rule.

Rule 1 — AWS Root Activity (High)
AWSCloudTrail
| where UserIdentityType =~ "Root"
| where EventName !startswith "List" and EventName !startswith "Describe"


Schedule: 5 min; Severity: High
Entity mapping: Account, IP, User.
Playbook: “Disable‑SSO‑User + Block‑Egress”.

Rule 2 — KMS Decrypt Spike (Medium/High)
AWSCloudTrail
| where EventSource == "kms.amazonaws.com" and EventName in ("Decrypt","GenerateDataKey","GenerateDataKeyWithoutPlaintext")
| summarize cnt=count() by bin(TimeGenerated, 15m), UserIdentityArn
| where cnt > 20

Rule 3 — DNS Novelty + Deny (Medium)
union isfuzzy=true
(Route53ResolverDNSLogs | project TimeGenerated, QueryName, SrcIpAddr=SrcIpAddr),
(AzureDiagnostics | where Category =~ "AzureFirewallDnsProxy" | project TimeGenerated, QueryName=msg_s, SrcIpAddr)
| summarize dcount(QueryName) by bin(TimeGenerated, 1h), SrcIpAddr
| where dcount_QueryName > 50

Rule 4 — GCP High Findings (High)
GCP_Alert
| where Severity in ("HIGH","CRITICAL")

🤖 7) SOAR Playbooks (Logic Apps)

Create Logic Apps and attach them to rules via Automation rules.

Playbook A — Block Egress Everywhere

AWS: network-firewall:UpdateRuleGroup (add domain/IP to deny list).

Azure: Update Azure Firewall DNAT/Network rule collection to block FQDN/IP.

GCP: Add VPC FW egress rule to drop target IP/port.

Playbook B — Disable Identity

Entra: Block sign‑in for user; revoke sessions.

GCP: Disable service account or remove key.

AWS SSO: Remove permission set assignment (or disable via IdP).

Playbook C — Isolate Host

Tag VM with quarantine=true; NSG/SG forced deny; detach public IP; snapshot disks.

Playbook D — Ticket & Notify

Create P1 in Jira/ServiceNow; post to SOC Slack/Teams; attach incident context.

Keep playbooks idempotent and parameterized (tenant/account/project identifiers as inputs).

🧪 8) Validation

Trigger test GuardDuty finding or GCP SCC finding.

Generate AWS CloudTrail ConsoleLogin from a controlled IP.

Query DNS to a random domain → verify deny + incident.

Confirm playbooks executed (egress blocks, identity disabled).

Measure MTTD/MTTR.

💰 9) Cost & Retention

LAW Retention: 30–60 days hot.

Archive raw logs to Blob/S3/GCS (12–365 months).

Use Data Collection Rules / sampling on high‑card logs; never sample DNS/Firewall.

🛑 10) Troubleshooting
Symptom	Likely Cause	Fix
No AWS logs arriving	S3→SQS wiring or role trust missing	Re‑run connector wizard; check S3 events
GCP connector silent	Pub/Sub IAM missing	Grant subscriber role to connector SA
Rule never triggers	Table names differ	Open connector docs; adjust KQL
Playbook fails	API permissions	Grant per‑cloud roles to Logic App MSI
📝 11) Binder — Errors & Fixes
[2025-xx-xx] AWS CloudTrail not parsed.
Fix: Installed AWS solution pack; reconnected S3/SQS with correct prefix filter.

[2025-xx-xx] GCP connector permission denied.
Fix: Granted roles/pubsub.subscriber to Sentinel connector SA.

[2025-xx-xx] Playbook couldn't update AWS NFW.
Fix: Added IAM role with network-firewall:UpdateRuleGroup to Logic App connection.

🧠 12) Summary

You’ve built United Airline’s SOC nervous system:

Central ingestion across AWS, Azure, GCP

ATT&CK‑aligned detections

Playbooks that act across clouds

Governance over cost and retention

Your security program now sees, decides, and responds—not just stores logs.
