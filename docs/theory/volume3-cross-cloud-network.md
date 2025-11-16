🧭 1. Purpose of Volume 3

Volumes 1 and 2 built the secure core inside AWS:

V1 → Hardened private hub

V2 → Centralized egress + deep packet inspection

Now Volume 3 expands United Airline’s network into multi-cloud by connecting:

AWS Transit Gateway (TGW)

Azure Virtual WAN (vWAN + Hub)

GCP Cloud Router + Cloud VPN / Interconnect

This chapter serves as the air-traffic control blueprint for how United Airline securely links its clouds into a single, global network fabric.

By the end of this volume, United Airline will have:

Private routing between all clouds

Zero Trust segmentation across clouds

Cross-cloud DNS integration

Resilient VPN/IPSec tunnels

Optional hybrid Interconnect connections

Flow-log-monitoring across all environments

Secure, auditable communication paths

This enables future Volumes (Identity, KMS, SIEM) to operate across all clouds, not just AWS.

🛫 2. Analogy: International Flight Corridors

Think of each cloud as a country with its own airports, airspace rules, and border controls:

Airline Analogy	Digital Cloud Equivalent
Airport hub	Cloud VPC/vNet/VPC-net
International flight corridor	IPSec tunnel / Interconnect
Air Traffic Control	TGW / Azure vWAN / Cloud Router
Customs & immigration	Firewall + policy rule sets
Flight routing	BGP dynamic routing
Country-to-country agreements	Cloud peering + VPN policies

Just like real international air travel:

Only approved corridors exist

Traffic is inspected and logged

Pathways are redundant and resilient

Each side must authenticate and negotiate routes

Nothing crosses borders without security checks

This is exactly what United Airline’s multi-cloud network does.

🧱 3. High-Level Architecture Overview

The United Airline multi-cloud network is built on three core pillars:

1. AWS Transit Gateway (TGW)

Central cloud backbone

Connects AWS hub + spokes

Acts as “primary airport hub”

2. Azure Virtual WAN (vWAN Hub)

Regional hub per Azure region

Auto-managed routing

Perfect for enterprise & hybrid

3. GCP Cloud Router + VPN/Interconnect

Dynamic BGP routing

Multi-region spokes

Connects workloads to the global fabric

These three are linked using encrypted IPSec tunnels or high-speed interconnects.

🌐 4. Unified Multi-Cloud Architecture (Mermaid)
flowchart LR

    subgraph AWS
      AWSTGW[AWS Transit Gateway]
      AWSHUB[Hub VPC]
      AWSHUB --> AWSTGW
    end

    subgraph AZURE
      VWAN[Azure vWAN Hub]
      AVNET[Azure Spoke vNets]
      AVNET --> VWAN
    end

    subgraph GCP
      GCPR[Cloud Router]
      GCPVPC[GCP VPC]
      GCPVPC --> GCPR
    end

    AWSTGW <---> VWAN
    VWAN <---> GCPR
    AWSTGW <---> GCPR


This creates a triangle architecture where any cloud can communicate with any other cloud through a controlled, logged, and inspected path.

🧬 5. Connectivity Options Per Cloud
🅰️ AWS ↔ Azure
Primary Options:

IPSec VPN + BGP

Most common

Automatic route advertisement

Direct Connect ↔ ExpressRoute (via partner)

High bandwidth

Enterprise-grade redundancy

More expensive

Why IPSec is chosen in United Airline:

Automated Terraform

No extra provider

Cost-efficient

Easily scaled to multiple regions

🅱️ AWS ↔ GCP
Connectivity Options:

IPSec VPN (HA VPN)

Simple

Auto BGP

Region-agnostic

Dedicated Interconnect

Ultra-high bandwidth

Lower latency

Enterprise-level cost

United Airline choice:

HA VPN + Cloud Router for reliability + automation.

🅲️ Azure ↔ GCP
Options:

IPSec VPN + BGP

Partner Interconnect → ExpressRoute

United Airline approach:

Use the same secure IPSec model for consistency.

🔐 6. Security Principles for Cross-Cloud Traffic
1. Zero Trust Segmentation

Even after connecting, clouds do not trust each other.

Subnets in:

AWS app tier

Azure app tier

GCP app tier

cannot talk unless explicitly allowed through:

Firewall rules

Route tables

Network security groups

Identity-based controls

2. Centralized Egress Inspection

All outbound traffic still goes through AWS Network Firewall (Volume 2).

This is key:

“Connecting clouds does NOT open internet pathways.”

3. Mutual Authentication

BGP + IPSec enforce:

Identity

Integrity

Encryption

Each cloud verifies the other.

4. Route Control

You explicitly control:

Which VPC/vNet receives routes

Which prefixes are exported

Which are filtered

Preventing accidental:

0.0.0.0/0 leaks

Overlapping CIDRs

Route hijacks

5. Logging Everywhere

Each cloud logs:

Flow logs

Firewall logs

VPN session events

BGP route changes

These feed into Volume 6 SIEM.

🧩 7. Routing Topologies
✔ Hub-and-Spoke (Recommended for United Airline)

AWS TGW ↔ Azure vWAN ↔ GCP Router
Each cloud has:

One hub

Many spokes

One inspection VPC (AWS)

Reason:

Maximum transparency

Easy policy enforcement

Easy region expansion

✔ Full Mesh (Not recommended)

AWS ↔ Azure
AWS ↔ GCP
Azure ↔ GCP

This is:

Harder to scale

Harder to monitor

Harder to control

Risky for route leakage

United Airline uses a hybrid-hub mesh, not full mesh.

📡 8. DNS Architecture for Multi-Cloud

DNS across clouds is handled by:

✔ Route53 Resolver (AWS)
✔ Azure DNS Private Resolver
✔ GCP Cloud DNS + forwarding policies

Goal:

AWS ↔ Azure ↔ GCP resolve internal services

No DNS goes to public resolvers

DNS queries pass through firewall logs for inspection

Split-horizon DNS avoids data leaks

This is mandatory for:

Identity federation

KMS federation

Cross-cloud application calls

Service mesh (future option)

📊 9. Failure Domain Design

United Airline designs for:

Cloud region failure

AZ failure

VPN tunnel failure

Route propagation failure

High-availability via:

Dual tunnels per cloud pair

BGP failover

Health checks

Secondary cloud routing

Multiple edge devices

This ensures:

“No single cloud controls United Airline’s uptime.”

🧨 10. Threat Model (STRIDE)
Threat	Example	Mitigation
S – Spoofing	Fake route injection	BGP auth, IPSec IKEv2
T – Tampering	Packet modification	End-to-end encryption
R – Repudiation	“Route was never changed”	Route logs + CloudTrail
I – Info Disclosure	Data leaking across clouds	Firewall + segmentation
D – Denial of Service	Tunnel flooding	HA VPN + firewall
E – Elevation	Bypass TGW	Explicit routes only
🧠 11. Summary

Volume 3 extends the United Airline environment into a global multi-cloud fabric.

You now have:

AWS TGW hub

Azure vWAN hub

GCP Cloud Router hub

Encrypted IPSec tunnels

Cross-cloud route sharing

Full logging & segmentation

This enables:

Identity federation (V4)

Multi-cloud KMS coordination (V5)

SIEM & SOAR analytics (V6)

Global resilience (V7)

Your architecture now behaves like:

A digital multinational airline with unified, secure airspace across three clouds.
