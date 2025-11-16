✈️ United Airline — Volume 5
Multi-Cloud Data Security & KMS Federation

SecureTheCloud.dev — Binder Series

🧭 1. Purpose of Volume 5

Volumes 1 to 4 built:

Secure hardened networks

Centralized egress inspection

Cross-cloud routing

Unified identity federation

Now Volume 5 introduces the data layer, which is the heart of airline systems.

United Airline handles incredibly sensitive data:

Passenger personal information (PII)

Payment card data (PCI)

Flight logs & aircraft health telemetry

Baggage tracking events

Loyalty program data

Crew scheduling

Operational analytics

This data moves across AWS, Azure, and GCP, so you need:

Consistent encryption model

Key hierarchy across clouds

Secure key lifecycle

Zero-trust access to encryption keys

Federated access controls

Protection from insider threats

Defense against cross-cloud exfiltration

This volume defines the United Airline Multi-Cloud KMS Federation Model.

🛫 2. Analogy: Airline Vault System

Think of the KMS layer as airport vaults that store:

Passports

Cash

Crew badges

Restricted flight data

Rules of the vault:

Physical Airport Vault	Digital KMS Equivalent
One vault master key	Cloud KMS root key
Vault managers	KMS key administrators
TSA requires identity check	IAM & RBAC for KMS
Logs track every access	CloudTrail / Audit logs
Vaults in multiple airports sync	Multi-cloud key federation
No single person can open the vault	Separation of duties (admin vs user roles)

A global airline needs vault consistency across countries.
United Airline needs encryption consistency across clouds.

🧱 3. United Airline Data Security Model (High-Level)

The Multi-Cloud KMS architecture is built on:

✔ AWS KMS
✔ Azure Key Vault (KV)
✔ GCP Cloud KMS

These form a federated encryption boundary using:

Key hierarchy standards

Shared naming conventions

Federated access policies

Encrypted transit paths (TLS, IPSec)

Cross-cloud AKE (Authenticated Key Exchange)

Short-lived tokens from Entra ID

🌐 4. Multi-Cloud KMS Architecture Diagram
flowchart LR

subgraph AWS
  AWSKMS[AWS KMS<br>Key Hierarchy<br>CMK + Aliases]
  AWSDATA[S3 / RDS / DynamoDB / EKS Secrets]
end

subgraph AZURE
  AZKV[Azure Key Vault<br>HSM-Backed Keys]
  AZDATA[Blob / SQL / Cosmos / AKV Secrets]
end

subgraph GCP
  GCPKMS[GCP Cloud KMS<br>Key Rings + Keys]
  GCPDATA[GCS / CloudSQL / BigQuery]
end

subgraph ENTRA
  IDP[Microsoft Entra ID<br>OIDC + SAML + Workload Federation]
end

IDP --> AWSKMS
IDP --> AZKV
IDP --> GCPKMS

AWSKMS --> AWSDATA
AZKV --> AZDATA
GCPKMS --> GCPDATA

AWSKMS <---> AZKV
AWSKMS <---> GCPKMS
AZKV <---> GCPKMS


This shows the cross-cloud trust surfaces and key usage flows.

🔐 5. Key Hierarchy Model (Airline-Specific)

United Airline uses a global KMS hierarchy patterned after real enterprise standards:

Level 0 — Root Key

Cloud-managed

Never exported

Used only to encrypt Level 1 keys

Level 1 — Environment Master Keys (EMK)

Example:

ua-prod-master

ua-dev-master

ua-nonprod-master

Used to encrypt Level 2 keys per cloud.

Level 2 — Service Keys

Example per cloud:

ua-flightops-key

ua-passenger-data-key

ua-loyalty-key

ua-billing-pci-key

Level 3 — Data Keys (DEK)

Generated per use:

S3 object-level

Application-level encryption

RDS Transparent Data Encryption

BigQuery column encryption

CosmosDB encryption

Keys never leave the cloud KMS.
Only short-lived data keys are returned to workloads.

📦 6. Encryption Models Used by United Airline
Model 1 — Server-Side Encryption (SSE-KMS)

Used for:

S3 buckets

GCS buckets

Azure Blob Storage

CloudSQL / RDS

DynamoDB, CosmosDB

Model 2 — Application-Level Encryption (ALE)

Used for:

Passenger PII

Crew health/medical data

Loyalty tokens

PCI data

Secrets

Applications request:

Short-lived DEK

Encrypt locally

Upload ciphertext only

Model 3 — Envelope Encryption

Used for:

TLS termination

Service mesh identity tokens

Multi-cloud workload identity

🧬 7. Access Control Model (Zero Trust KMS)

The key principles:

✔ Separation of Duties

Admins manage keys.
Apps use keys.
Admins cannot decrypt data.

✔ Fine-Grained IAM Policies

Example AWS IAM KMS policy:

Developer:

encrypt = ALLOW

decrypt = ALLOW

key deletion = DENY

Admin:

describe = ALLOW

disable key = ALLOW

decrypt = DENY

✔ Conditional Access + Device Compliance

Identity is validated before key usage.

✔ No shared keys

Every system has its own key, even inside same service.

✔ Algorithm Consistency

United Airline uses:

AES-256-GCM

RSA-4096 where required

P-256 for signatures

🌍 8. Cross-Cloud Key Drift Problem (Solved)

In multi-cloud environments, keys can drift:

Different naming

Different versions

Different access policies

Different lifecycle dates

United Airline solves this by enforcing:

Unified standards across clouds

Namespace format:

ua-<service>-<env>-key

Key rotation schedule

Automatic

Every 90 days

Logged

Federation-aware

Policy parity

Equivalent IAM controls in:

AWS KMS policy

Azure Access Policy

GCP IAM policy

This ensures consistent security posture.

🛠️ 9. KMS Integration with Network (Volumes 1–3)

The data layer integrates with previous volumes:

✔ Volume 1: AWS Hub

Applications get KMS access only from private subnets.

✔ Volume 2: Network Firewall

Outbound KMS API calls are allow-listed only to:

AWS KMS

Azure KV

GCP KMS

✔ Volume 3: Multi-cloud routing

Encrypted KMS traffic moves securely through tunnels with:

IPSec

BGP routing

Firewall inspection

📊 10. Logging & Monitoring

Every key use is logged:

AWS

CloudTrail KMS events

KMS key usage logs

Key rotation logs

Azure

Azure Monitor

Key Vault Audit Logs

Managed HSM logs

GCP

Cloud Audit Logs

KMS key version access

Data access logs

Logs feed into Volume 6 SIEM.

🛑 11. Threat Model (STRIDE)
Threat	Example	Mitigation
Spoofing	Fake app requests decrypt	KMS IAM + OIDC federation
Tampering	Modify ciphertext	AES-GCM integrity checks
Repudiation	Users deny decrypting	Audit logs + identities
Info Disclosure	Exfiltrated data in clear	Envelope encryption only
DoS	KMS API flood	Rate limiting + throttling
Elevation	Admin decrypts data	Admin decrypt = DENY policy

KMS is designed under “assume breach” principles.

🧠 12. Summary

Volume 5 establishes the Data Security & Encryption layer of United Airline:

Unified multi-cloud KMS architecture

Key hierarchy for PII, PCI, flight ops, loyalty data

Envelope encryption for all workloads

No plaintext stored anywhere

Cross-cloud key consistency

Logging & audit trails

Zero Trust IAM for key usage

Secure key lifecycle management

Integrated with Volumes 1–3 network models

This is the backbone of protecting airline-sensitive data globally.
