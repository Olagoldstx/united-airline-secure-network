✈️ United Airline — Volume 2
Centralized Egress & Deep Packet Inspection (AWS Network Firewall + GWLB)

SecureTheCloud.dev — Binder Series

🧭 1. Purpose of Volume 2

In Volume 1, we built the Zero-to-Hardened AWS Hub — a private-only, logged, zero-trust VPC with no internet access.

Volume 2 upgrades the network from hardened to enterprise-grade by introducing:

Centralized Egress Filtering

Deep Packet Inspection (DPI)

AWS Network Firewall (NFW)

Gateway Load Balancer (GWLB)

Inspection VPC Architecture

Egress Allow Lists

DNS Filtering & Logging

Secure traffic paths from all subnets and future multi-cloud spokes.

This is required before United Airline can:

Connect Azure & GCP (Volume 3)

Support workload egress securely

Protect against data exfiltration

Enforce Zero Trust at the packet layer

Egress control is the nerve center of real enterprise cloud security.

🛫 2. Analogy: TSA Security Checkpoint for Outbound Traffic

Think of AWS Network Firewall as the TSA screening area for departing traffic — not passengers boarding the plane, but data leaving your cloud.

Aviation Concept	AWS Equivalent
TSA scanners	AWS Network Firewall
Central terminal checkpoint	Centralized Egress VPC
Clear lane	Egress allow lists
No-fly list	Domain/IP deny lists
Random checks	Stateful inspection / Suricata rules
Baggage scan	Deep packet inspection

Just as TSA prevents:

Weapons

Contraband

Suspicious behavior

Prohibited items

Your NFW prevents:

Malware

Data leaks

Unauthorized outbound traffic

Rogue protocols

DNS tunneling

Exfiltration via HTTPS

United Airline must ensure:

“What leaves our cloud is as important as what enters it.”

🧱 3. Architecture Overview — Centralized Egress & Inspection
High-Level Flow (Day-2)
flowchart LR
  APP[App Subnets] --> RT1[Route Table]
  DATA[Data Subnets] --> RT2[Route Table]
  MGMT[Mgmt Subnets] --> RT3[Route Table]

  RT1 --> TGW[TGW (Future)]
  RT2 --> TGW
  RT3 --> TGW

  RT1 --> GWLBEP[GWLB Endpoint]
  RT2 --> GWLBEP
  RT3 --> GWLBEP

  GWLBEP --> GWLB[Gateway Load Balancer]
  GWLB --> NFW[AWS Network Firewall]

  NFW --> NAT[NAT Gateway (optional)]
  NFW --> INTNET((Internet))

  NFW --> DNSF[DNS Filtering & Logging]

Key Notes:

ALL outbound traffic must pass the NFW.

Subnets do not route directly to the Internet or NAT.

GWLB endpoints ensure transparent insertion (no app changes).

DNS filtering protects against tunneling and malicious domains.

This design scales horizontally for heavy workloads.

🛡️ 4. Security Goals of Volume 2
1. Control every packet leaving AWS

Workloads cannot talk directly to the Internet.

2. Enforce Egress Zero Trust

Allow only:

Required SaaS endpoints

Required cloud APIs

DNS

OS package updates

Monitoring agents

Everything else: BLOCK.

3. Detect and stop suspicious activity

Network Firewall provides:

Stateful firewalling

DPI (deep packet inspection)

Suricata rules engine

Domain filtering

Protocol enforcement

4. Prevent data exfiltration

Block:

Uploads to unknown IPs

DNS tunneling

HTTPS tunnels to random domains

SSH outbound

SMTP outbound

IRC/peer-to-peer

5. Centralize logging

Firewall logs → CloudWatch → Volume 6 SIEM.

🔐 5. AWS Components Used in Volume 2
A. AWS Network Firewall (NFW)

Stateful rules

Suricata rules

Domain lists (FQDN allow/deny)

Logging (alert + flow)

B. AWS Gateway Load Balancer (GWLB)

Transparent traffic steering

Auto-scaling insertion

No app or subnet changes

GWLB endpoints in hub & spokes

C. Inspection VPC

A dedicated VPC hosting:

Network Firewall

Subnets for firewall endpoints

Logging pipelines

D. Route Tables

Each app/data/mgmt subnet routes ALL traffic to the GWLB endpoint.

E. NAT

Optional, but traffic must pass NFW first.

🧬 6. Layered Egress Control Model
1. DNS Layer

Route53 Resolver Outbound

Domain allow/deny lists

DNS logs

2. L3/L4 Layer

IP allow/deny

Port-based rules

Stateful firewall

3. Layer 7 Layer

Suricata rules

Deep packet inspection

4. Threat Intelligence

Block known malicious IPs/domains

This is true Zero Trust Egress.

🌐 7. Egress Allow-List Philosophy

United Airline’s model uses:

FQDN-based allow lists

Examples:

amazonaws.com

microsoft.com

gstatic.com

ubuntu.com

yum.aws

docker.com

Everything else = blocked by default.

This prevents:

Ransomware callback

Data exfiltration

Zero-day C2 communication

Traffic to unapproved SaaS

📊 8. Logging & Monitoring

Network Firewall sends 2 log streams:

1. Flow Logs

Every connection:

src/dst

ports

action (allow/deny)

packet counts

2. Alert Logs

When Suricata rules match:

Malware patterns

DNS tunneling

Suspicious exfiltration

Protocol anomalies

These logs move to Volume 6 for SIEM correlation.

🧩 9. Threat Model (STRIDE)
Threat	Example in Airline Context	Mitigation
S – Spoofing	Fake outbound IP claiming to be AWS	Domain validation + DPI
T – Tampering	Modify packets leaving	Stateful inspection
R – Repudiation	“That traffic wasn’t mine”	NFW flow logs
I – Information Disclosure	Exfiltrate passenger data	FQDN limits + deny lists
D – DoS	Outbound connection storms	Firewall rate limits
E – Elevation of Privilege	App bypassing firewall	No direct path; RT enforced
🧱 10. How Volume 2 Fits the Bigger Picture

Volume 2 is mandatory before:

Volume 3

Cross-cloud routing via TGW/vWAN/GCP Router.

Volume 4

Identity federation across clouds.

Volume 5

KMS hierarchy for protecting encrypted data in motion.

Volume 6

SIEM correlation using firewall logs.

Volume 7

Multi-region resilience (firewall failover).

Volume 8

AI ingestion & analytics (requires secure egress for telemetry).

📝 11. Errors & Fixes (Binder Section)

Document your real errors during deployment:

[2025-xx-xx] NFW endpoint creation blocked due to missing AZ pair.
Fix: Added inspection subnets in 2 AZs.

[2025-xx-xx] GWLB endpoint not reachable.
Fix: Updated route tables; enforced private routing paths.

[2025-xx-xx] DNS still leaking to public.
Fix: Removed IGW; forced Route53 outbound-only.

🧠 12. Summary

Volume 2 introduces the most important security control in United Airline’s network:

ALL outbound traffic must pass through a firewall that logs, inspects, filters, and enforces Zero Trust at every layer.

This protects:

Passenger PII

Flight operations

Crew systems

Loyalty systems

Payment data

Corporate systems

Cloud workloads

Cross-cloud traffic

This is the point where your architecture becomes enterprise hardened.
