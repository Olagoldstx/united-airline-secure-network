✈️ United Airline — Secure Multi-Cloud Architecture (Volumes 0–8)

A complete, enterprise-grade, multi-cloud architecture built across AWS, Azure, and GCP, following Zero-Trust, Defense-in-Depth, and Airline-class resilience standards.

🛡️ Project Status








All badges above link to real sections in this README.

🗺️ Architecture Overview (Everything at a Glance)
flowchart TB

subgraph Network["Network & Perimeter (V1–V3)"]
  HUB[AWS Hub VPC]
  FW[Egress Firewall (NFW + GWLB)]
  TGW[AWS TGW]
  VWAN[Azure vWAN]
  GCPR[GCP Cloud Router]
  HUB --> FW --> TGW
  TGW <---> VWAN
  TGW <---> GCPR
end

subgraph Identity["Identity & Access (V4)"]
  ENTRA[Microsoft Entra ID]
  AWS_SSO[AWS IAM Identity Center]
  GCP_WIF[GCP Workforce Identity Federation]
  ENTRA --> AWS_SSO
  ENTRA --> GCP_WIF
end

subgraph Data["Data Security (V5)"]
  AWS_KMS[AWS KMS]
  AZ_KV[Azure Key Vault]
  GCP_KMS[GCP Cloud KMS]
  AWS_KMS <---> AZ_KV
  AWS_KMS <---> GCP_KMS
end

subgraph Detection["SIEM & SOAR (V6)"]
  SENT[Microsoft Sentinel]
  GD[GuardDuty]
  SCC[GCP SCC]
  LOGS[DNS + Firewall Logs]
  GD --> SENT
  SCC --> SENT
  LOGS --> SENT
end

subgraph Resilience["Resilience & DR (V7)"]
  AWS_DR[AWS DR Region]
  AZ_DR[Azure DR]
  GCP_DR[GCP DR]
end

subgraph AI["AI, Analytics & Sustainability (V8)"]
  KINESIS[AWS Kinesis]
  SYN[Azure Synapse]
  BIGQ[BigQuery]
  VAI[Vertex AI]
  KINESIS --> SYN --> BIGQ --> VAI
end

📚 Binder Volumes

Each volume includes:
✔ Theory (textbook style)
✔ Lab (Terraform + scripts)
✔ Architecture diagram
✔ Binder “Errors & Fixes”

Volume Index (Clickable)
Vol	Title	Theory	Lab
V0	Foundation	Theory
	—
V1	Zero-to-Hardened AWS Hub	Theory
	Lab

V2	Egress Firewall + DPI	Theory
	Lab

V3	Cross-Cloud Network (AWS ↔ Azure ↔ GCP)	Theory
	Lab

V4	Identity Federation (Entra → AWS/GCP)	Theory
	Lab

V5	Multi-Cloud KMS & Data Security	Theory
	Lab

V6	SIEM & SOAR	Theory
	Lab

V7	Resilience & DR	Theory
	Lab

V8	AI, Analytics & Sustainability	Theory
	Lab
💾 (Optional) Master Binder PDFs

(To be re-generated later)

Volumes 1–4 Binder

Volumes 5–8 Binder

(PDF generation is currently paused until ready to export.)

🎯 Purpose of This Repository

This repo is:

A full enterprise multi-cloud reference architecture

A Zero-Trust security blueprint

A portfolio project for real consulting

A teaching reference for SecureTheCloud.dev

A production-ready example for highly regulated industries (like airlines)

🧩 Folder Structure
united-airline-secure-network/
│
├── docs/
│   ├── theory/      # All volume theories
│   ├── binder/      # PDFs (future)
│   └── architecture/ 
│
├── labs/
│   ├── volume1-aws-hub/
│   ├── volume2-egress-inspection/
│   ├── volume3-cross-cloud-network/
│   ├── volume4-identity-federation/
│   ├── volume5-data-kms/
│   ├── volume6-siem-soar/
│   ├── volume7-resilience-dr/
│   └── volume8-ai-sustainability/
│
├── terraform/
│   ├── envs/
│   └── modules/
│
└── diagrams/

🙌 Credits

Created by Ola Omoniyi (Olagoldstx)
Founder — SecureTheCloud.dev
Multi-Cloud Security Architect | AWS | Azure | GCP | Kubernetes | Zero-Trust | DevSecOps
