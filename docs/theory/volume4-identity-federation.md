🧭 1. Purpose of Volume 4

Volumes 1–3 built the network foundation for the United Airline multi-cloud architecture:

V1: Hardened AWS Hub

V2: Centralized egress + deep packet inspection

V3: Multi-cloud routing (AWS ↔ Azure ↔ GCP)

Now Volume 4 introduces the identity layer — the most critical part of any Zero Trust architecture.

The purpose of this volume is to design a unified identity plane for the entire United Airline digital ecosystem, across all clouds and services.

United Airline will use:

Microsoft Entra ID (formerly Azure AD)

as the single enterprise identity provider (IdP) for:

AWS IAM Identity Center (SSO)

Azure (native)

GCP Workforce Identity Federation

SaaS apps

Crew portals

Admin portals

Contract engineer access

DevOps tooling

This chapter defines the entire identity architecture:

Identity federation

SAML + OIDC trust

SCIM provisioning

Access governance

Role mapping

Conditional access policies

Multi-cloud Zero Trust IAM model

Credential hygiene

Workload identity

This is one of the most important volumes in the entire binder.

🛫 2. Analogy: Airport Staff Identity Model

Identity in an airline is very similar to airport operations.

Airline Real World	Digital Identity Parallel
Pilot credentials	Admin identity
Flight attendant badge	Developer/crew identity
Passenger passport	Application identity
Boarding gates	Access control policies
TSA security checks	MFA + Conditional Access
Airport zones (secure areas)	Least privilege RBAC
Customs checks	Continuous authentication

Just as airports verify, validate, and continuously authorize staff and passengers, United Airline’s digital systems must:

Authenticate

Authorize

Continuously evaluate trust

Enforce least privilege

Revoke access quickly

Identity → is the new network perimeter.

🧱 3. High-Level Identity Architecture
🧠 United Airline’s Identity Centerpiece:

Microsoft Entra ID serves as the authoritative identity provider for:

Workforce (employees)

Crew (flight operations)

Developers / engineers

Contractors / vendors

Automated service accounts

CI/CD pipelines

Cloud workloads

This identity is federated into:

AWS

IAM Identity Center (SSO)

OIDC federation for workloads

IAM role assumption using Entra identities

SCIM provisioning (users + groups)

Azure

Native directory

Conditional Access enforcement

Admin portal

Workload identities (Workload ID federation)

GCP

Workforce Identity Federation

Workload Identity Federation

Service Account impersonation

SaaS

Okta-style SAML apps

OIDC native apps

API access control

Beyond cloud

VPN

WiFi

Enterprise network

Secure desktops

Flight operations systems

🔐 4. Zero Trust Identity Principles (United Airline)

United Airline adopts NIST 800-207 Zero Trust Identity principles:

1. Verify Explicitly

MFA

Conditional Access

Device compliance

IP/location checks

Real-time risk evaluation

2. Least Privilege Access

RBAC

ABAC (attribute-based access control)

Just-in-time elevation

Time-bound access

3. Assume Breach

Credential hygiene

No long-lived keys

Passwordless preferred

Rotating secrets

Continuous monitoring

4. Access at Runtime

Identity is verified at every request, not just login.

5. Continuous Authorization

User and workload identity revalidated every session based on:

User risk

Device risk

Network risk

Role change

Access pattern

🌐 5. Architecture Diagram — Identity Federation
flowchart TB

subgraph EntraID[Microsoft Entra ID]
  USERS[Users / Groups<br>Employees / Crew / Contractors]
  SCIM[SCIM Provisioning]
  CAP[Conditional Access Policies]
end

subgraph AWS
  SSO[AWS IAM Identity Center]
  SSOROLE[SSO Permission Sets<br>IAM Roles]
  OIDC_A[OIDC Federation for Workloads]
end

subgraph AZURE
  AVNET[Azure AD Native]
  WORKLOAD_ID[Entra Workload Identity]
end

subgraph GCP
  WIF[GCP Workforce Identity Federation]
  WLF[GCP Workload Identity Federation]
end

USERS --> SCIM --> SSO
SSO --> SSOROLE
USERS --> WIF
USERS --> AVNET
AVNET --> WORKLOAD_ID
USERS --> CAP
SSO --> OIDC_A
WIF --> WLF

🧩 6. AWS Identity Federation Details
6.1 Federation Method

United Airline uses SAML 2.0 for:

Human login

AWS console

CLI access (via IAM Identity Center)

6.2 Role Mapping

Entra Groups → AWS Permission Sets → IAM Roles

Examples:

Entra Group	AWS Permission Set	Description
ua-admins	AdministratorAccess	Cloud admins
ua-devops	PowerUserAccess	Airline platform engineers
ua-crew-ops	ReadOnlyAccess	Crew operations staff
ua-contractors	CustomLeastPrivilege	Vendor-controlled roles
6.3 SCIM Provisioning

Automatically sync:

Users

Group memberships

Role assignments

This keeps AWS identities aligned with HR lifecycle.

6.4 OIDC Workload Federation

AWS resources authenticate to Entra ID using:

JWT

Short-lived tokens

Trust policy mapped to Entra identity

Used for:

GitHub Actions

DevOps pipelines

Azure-hosted systems calling AWS APIs

Serverless workloads

🧩 7. Azure Identity (Native)

Azure acts as the source of truth and home of:

Users

Groups

Conditional Access policies

MFA policies

Workload Identities

Cloud-native RBAC

Azure hosts:

Enterprise apps (SaaS integrations)

Admin access portal

Zero Trust evaluation layer

Entra ID’s risk policies apply to all clouds.

🧩 8. GCP Workforce Identity Federation

Used for logging into GCP without Google accounts.

GCP WIF allows:

Azure AD users to access GCP using Azure credentials

Zero long-lived service account keys

Scoped, short-lived credentials

Secure CLI access

Entra users authenticate → GCP issues temporary access token.

🧩 9. Workload Identity Model

Workloads (not users) need identity too:

AWS

OIDC provider

IRSA for Kubernetes

Federated workloads

Azure

Workload identity tokens

Federated identity credentials

GCP

Workload identity federation

Service account impersonation

Why?

Because no cloud should keep long-lived keys.

🔒 10. Conditional Access — Airline-Grade Zero Trust

United Airline uses strict enforcement:

✔ MFA for everyone
✔ Require compliant corporate devices
✔ Block legacy authentication
✔ Impossible travel detection
✔ Block login outside approved regions
✔ Step-up MFA for sensitive apps
✔ Risk-based access decisions
✔ Passwordless for admins

This maps to real airline environments that require:

TSA-grade access control

Continuous identity verification

Strict audit trails

📋 11. Identity Segmentation Model

United Airline identity categories:

Persona	Description	Access Level
Admin	Cloud/platform engineers	High privilege, monitored
Crew Ops	Operational staff	Read-only or app-specific
Developers	App + service builders	Scoped engineer roles
Contractors	Temporary access	Time-bound permission sets
Automation	Pipelines, GitHub	Workload identity only
Applications	Serverless/K8s workloads	IRSA/WIF tokens

This segmentation is enforced across:

AWS IAM Identity Center

Azure RBAC

GCP IAM

🧨 12. Threat Model (STRIDE)
Threat	Identity Risk	Mitigation
S – Spoofing	Fake identity tokens	Conditional Access + MFA + signed JWT
T – Tampering	Manipulating login requests	Signed SAML + OIDC tokens
R – Repudiation	“I didn’t do that”	CloudTrail + Entra audit logs
I – Info Disclosure	Overprivileged access	Least privilege + Access reviews
D – DoS	Authentication floods	Conditional Access + throttling
E – Elevation	Privilege escalation	JIT access + separate admin identities
🧠 13. Summary

Volume 4 establishes United Airline’s global identity layer, where:

Entra ID is the single source of truth

AWS & GCP trust Azure identities

Users receive short-lived, least-privilege access

Workloads authenticate using passwordless OIDC tokens

Conditional Access enforces Zero Trust

SCIM ensures lifecycle alignment

All identity activity is logged centrally

This enables secure operations across:

Flight operations

Crew mobile systems

Ground systems

Services in AWS/Azure/GCP

DevOps pipelines

Data platforms

SaaS applications

Identity is now the new perimeter for United Airline.
