✈️ United Airline — Volume 7
Resilience, Disaster Recovery & Chaos Engineering (Multi-Cloud)

SecureTheCloud.dev — Binder Series

🧭 1. Purpose of Volume 7

Volumes 1–6 built the security and observability foundation for United Airline:

V1 — Hardened AWS Hub

V2 — Egress Firewall + DPI

V3 — Cross-cloud private routing

V4 — Identity Federation

V5 — Multi-Cloud KMS

V6 — SIEM + SOAR

Now, Volume 7 upgrades United Airline into a fault-tolerant, global, always-available airline by building:

✔ Multi-region resilience
✔ Multi-cloud failover
✔ DR at every layer (network, identity, data, workloads)
✔ Chaos engineering to test outage scenarios
✔ Failover runbooks and automated recovery

This is the “will the airline stay up during a cyberattack or regional outage?” chapter.

🛫 2. Analogy: Airline Fleet & Airport Continuity

Real airlines design for failure:

Airline Concept	Cloud Equivalent
Backup aircraft	Standby workloads in a second region
Diversion airports	Secondary Availability Zones and clouds
Alternate flight routes	Failover routing & BGP fallback
Crew reserves	Scaled-down standby compute
Operations Control Center (OCC)	DR automation & runbooks
Emergency simulators	Chaos engineering tools

If a storm closes Chicago O’Hare, flights divert to Denver.
If AWS us-east-1 fails, workloads shift to AWS us-west-2 or Azure or GCP.

This volume builds digital O’Hare-to-Denver operations continuity.

🧱 3. United Airline’s Multi-Cloud Resilience Strategy
The United Airline strategy = “Region → Cloud → Global” failover.
1. AZ-level failure → Load balancer / auto-scaling shifts to other AZs.
2. Region failure → Traffic shifts to warm DR region.
3. Cloud failure → Workloads fail over to another cloud (Azure or GCP).
4. Identity outage → Entra ID cross-region DR + backup federation.
5. KMS outage → Secondary region keys + cross-cloud envelope flows.
6. DNS outage → Multi-cloud DNS with health checks.


This ensures:

Apps stay online

Staff can authenticate

Passengers can book flights

Baggage & flight data keeps flowing

Flight operations continue safely

Airlines cannot have downtime.

🌐 4. Resilience Architecture (Multi-Cloud)
flowchart LR

subgraph AWS_RegionA[us-east-1 (Primary)]
  A1[EKS / EC2 / Serverless]
  A2[RDS Multi-AZ]
  A3[S3 Primary Bucket]
end

subgraph AWS_RegionB[us-west-2 (DR)]
  B1[Warm Standby Compute]
  B2[RDS Read Replica]
  B3[S3 CRR Bucket]
end

subgraph Azure_Region[Azure East US2]
  C1[AKS DR Cluster]
  C2[Storage Account Geo-Redundant]
end

subgraph GCP_Region[GCP us-central1]
  D1[GKE DR Cluster]
  D2[CloudSQL HA Replica]
end

A1 --> B1
A1 --> C1
A1 --> D1

A3 --> B3
A3 --> C1
A3 --> D1

A2 --> B2
B2 --> C2
C2 --> D2


This diagram shows the fallback paths:

Primary AWS Region → AWS DR Region

AWS → Azure (fallback cloud)

AWS → GCP (second fallback cloud)

🧩 5. Core Components of Resilience
✔ 5.1 Multi-AZ Architecture (Baseline)

Mandatory for all AWS/Azure/GCP workloads

Automatic failover for:

NLB/ALB/ELB

Managed databases

Auto-scaling groups

This is “local turbulence resistance”.

✔ 5.2 Multi-Region Architecture (Regional DR)

United Airline uses the Pilot Light / Warm Standby pattern:

Pilot Light (Critical Systems)

Identity

Core APIs

Databases

Flight operations

Baggage tracking

Payment systems

These have read replicas or standby compute ready to scale.

Warm Standby (Noncritical Systems)

Analytics

Machine Learning

Reporting

Scaled-down deploy, ready to expand.

✔ 5.3 Multi-Cloud DR (Cloud Outage Survival)
Why multi-cloud DR?

Because airlines must remain online even if:

A cloud provider has an outage

A region is compromised

A supply chain/identity outage happens

Failover path:
AWS → Azure → GCP
Azure → AWS → GCP
GCP → AWS → Azure


Cross-cloud workloads use:

Identity Federation (Volume 4)

KMS envelope keys (Volume 5)

Cross-cloud routing (Volume 3)

Egress Firewall for consistent controls (Volume 2)

✔ 5.4 Multi-Cloud DNS Failover

DNS is the air traffic controller of failover.

United Airline uses:

Azure Traffic Manager OR AWS Route53 Failover Routing

Health checks for:

API endpoints

Booking portal

Crew systems

DNS-driven redirects to:

Secondary AWS region

Azure AKS

GCP GKE

✔ 5.5 Data Replication Strategy
Object Storage

S3 Cross-Region Replication → Azure blob → GCS

Databases

RDS → cross-region read replica

DynamoDB global tables

CloudSQL HA + cross-region

CosmosDB multi-region

Secrets & Keys

KMS multi-region keys

Azure KV → GRS / Geo HSM

GCP Cloud KMS → multi-region

🔐 6. Identity Resilience

Identity = critical airline system.

United Airline ensures:

✔ Entra ID Multi-Region

All authentication is handled by global Entra regions.

✔ Backup Federation Paths

If SAML/OIDC endpoint fails → other region’s endpoint takes over.

✔ AWS SSO Offline Tokens

Short-lived tokens cached locally (CLI fallback).

✔ GCP WIF multi-region availability
✔ Conditional Access fallback

If risk system fails → “fail open” OR “fail closed” depending on persona.

🛡️ 7. Network Resilience

AWS TGW → dual-region

Azure vWAN → paired regions

GCP Cloud Router → multi-region

BGP multipath enabled

Health-probe-driven routing

Egress firewall in DR region

Cross-cloud tunnel redundancy

Network = redundant flight paths.

🧨 8. Chaos Engineering Scenarios

Use tools:

AWS Fault Injection Simulator

Azure Chaos Studio

GCP Fault Injection

Run tests:

Scenario 1 — Region Failure

Simulate AWS us-east-1 down

Expected:

DNS failover to us-west-2

RDS Promote Replica

ASG scale-up in DR region

SIEM events still flow

Scenario 2 — Identity Outage

Block Entra ID primary endpoint

Expected:

Failover to secondary region

AWS SSO continues using token cache

GCP WIF works through Google fallback

Scenario 3 — KMS Unavailable

Disable region-specific KMS key path

Expected:

Apps use multi-region KMS key

Envelope encryption fallback

Scenario 4 — Firewall Outage

Drop GWLB/Network Firewall endpoint

Routing automatically shifts to secondary endpoint

Scenario 5 — Database Corruption

Failover to DR replica

Promote read replica

Verify data consistency

Document each test in binder.

🧪 9. RTO & RPO Targets (Airline-Grade)

United Airline adopts strict SLAs:

Tier	System	RTO	RPO
Tier 0	Identity, KMS, Flight Ops	<= 5 min	0 data loss
Tier 1	Booking, Payments	<= 15 min	<= 5 min
Tier 2	Crew Ops, Cargo	<= 1 hour	<= 30 min
Tier 3	Analytics	<= 4 hours	<= 1 hour
📋 10. DR Runbooks

For each critical service:

Runbook Format
1. Detection
2. Impact Assessment
3. Failover Decision
4. Execute Failover Steps
5. Validation Checks
6. Customer/Crew Communications
7. Failback Conditions
8. Post-Incident Review

🛑 11. Threat Model (STRIDE)
Threat	DR Threat	Mitigation
Spoofing	Fake failover trigger	Signed health probes
Tampering	Modify routing tables	Infra-as-code only; GitOps
Repudiation	“We never initiated failover”	Logs across SIEM
Info Disclosure	DR region misconfig	KMS multi-region keys
DoS	Attack on primary region	Multi-region + multi-cloud
Elevation	DR roles abused	Entra conditional access
🧠 12. Summary

Volume 7 upgrades United Airline to a globally resilient airline IT platform with:

Multi-region redundancy

Multi-cloud failover

Resilient identity paths

Continuously validated DR posture

Chaos engineering built-in

Tiered RTO/RPO targets

Automated and manual runbooks

Your airline can now survive:

Region outages

Cloud outages

KMS failures

Identity outages

Network failures

Data corruption incidents

You now operate like a global enterprise-class airline with real-world disaster readiness.
