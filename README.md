<p align="center">
  <img src="https://raw.githubusercontent.com/Olagoldstx/united-airline-secure-network/main/docs/branding/securethecloud.png" 
       alt="SecureTheCloud Banner" 
       width="80%"/>
</p>

<p align="center">
---
## 📚 Volumes 0–8

<p align="center"><em>Click a title, theory, or lab to jump into that module.</em></p>

<p align="center">
  <table>
    <thead>
      <tr>
        <th align="center">Vol</th>
        <th align="left">Title</th>
        <th align="center">Theory</th>
        <th align="center">Lab</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td align="center"><strong>V0</strong></td>
        <td><a href="docs/theory/volume0-united-airline-foundation.md">Foundation</a></td>
        <td align="center"><a href="docs/theory/volume0-united-airline-foundation.md">Theory</a></td>
        <td align="center">—</td>
      </tr>
      <tr>
        <td align="center"><strong>V1</strong></td>
        <td><a href="docs/theory/volume1-zero-to-hardened-aws-hub.md">Zero-to-Hardened AWS Hub</a></td>
        <td align="center"><a href="docs/theory/volume1-zero-to-hardened-aws-hub.md">Theory</a></td>
        <td align="center"><a href="labs/volume1-aws-hub/">Lab</a></td>
      </tr>
      <tr>
        <td align="center"><strong>V2</strong></td>
        <td><a href="docs/theory/volume2-egress-inspection.md">Egress Firewall &amp; Inspection</a></td>
        <td align="center"><a href="docs/theory/volume2-egress-inspection.md">Theory</a></td>
        <td align="center"><a href="labs/volume2-egress-inspection/">Lab</a></td>
      </tr>
      <tr>
        <td align="center"><strong>V3</strong></td>
        <td><a href="docs/theory/volume3-cross-cloud-network.md">Cross-Cloud Network (AWS/Azure/GCP)</a></td>
        <td align="center"><a href="docs/theory/volume3-cross-cloud-network.md">Theory</a></td>
        <td align="center"><a href="labs/volume3-cross-cloud-network/">Lab</a></td>
      </tr>
      <tr>
        <td align="center"><strong>V4</strong></td>
        <td><a href="docs/theory/volume4-identity-federation.md">Identity Federation (Entra → AWS/GCP)</a></td>
        <td align="center"><a href="docs/theory/volume4-identity-federation.md">Theory</a></td>
        <td align="center"><a href="labs/volume4-identity-federation/">Lab</a></td>
      </tr>
      <tr>
        <td align="center"><strong>V5</strong></td>
        <td><a href="docs/theory/volume5-data-kms.md">Multi-Cloud KMS &amp; Data Security</a></td>
        <td align="center"><a href="docs/theory/volume5-data-kms.md">Theory</a></td>
        <td align="center"><a href="labs/volume5-data-kms/">Lab</a></td>
      </tr>
      <tr>
        <td align="center"><strong>V6</strong></td>
        <td><a href="docs/theory/volume6-siem-soar.md">SIEM &amp; SOAR</a></td>
        <td align="center"><a href="docs/theory/volume6-siem-soar.md">Theory</a></td>
        <td align="center"><a href="labs/volume6-siem-soar/">Lab</a></td>
      </tr>
      <tr>
        <td align="center"><strong>V7</strong></td>
        <td><a href="docs/theory/volume7-resilience-dr.md">Resilience &amp; DR</a></td>
        <td align="center"><a href="docs/theory/volume7-resilience-dr.md">Theory</a></td>
        <td align="center"><a href="labs/volume7-resilience-dr/">Lab</a></td>
      </tr>
      <tr>
        <td align="center"><strong>V8</strong></td>
        <td><a href="docs/theory/volume8-ai-sustainability.md">AI, Analytics &amp; Sustainability</a></td>
        <td align="center"><a href="docs/theory/volume8-ai-sustainability.md">Theory</a></td>
        <td align="center"><a href="labs/volume8-ai-sustainability/">Lab</a></td>
      </tr>
    </tbody>
  </table>
</p>


---

## 📁 Directory Structure

---

# ✈️ United Airline – Multi-Cloud Secure Architecture (Volumes 0–8)

A complete **airline-style** enterprise architecture across **AWS, Azure, and GCP**, built as a teaching, portfolio, and consulting asset for **SecureTheCloud.dev**.

---

## 📚 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Quick Navigation](#-quick-navigation)
- [Volumes 0–8](#-volumes-0-8)
- [Directory Structure](#-directory-structure)
- [Security & Support](#-security--support)
- [About](#-about)

---

## 🗺 Architecture Overview

```mermaid
flowchart TB
    subgraph FOUNDATION[Foundation & Governance]
        direction TB
        subgraph NET[Network & Perimeter Security]
            HUB[AWS Hub VPC]
            FW[Egress Firewall]
            TGW[AWS Transit Gateway]
            HUB --> FW --> TGW
            TGW <---> VWAN[Azure vWAN]
            TGW <---> GCPR[GCP Cloud Router]
        end

        subgraph IAM[Identity & Access Management]
            ENTRA[Microsoft Entra ID]
            ENTRA --> AWS_SSO[AWS IAM Identity Center]
            ENTRA --> GCP_WIF[GCP Workforce Identity Fed.]
        end

        subgraph SEC[Data Security & Encryption]
            AWS_KMS[AWS KMS]
            AZ_KV[Azure Key Vault]
            GCP_KMS[GCP Cloud KMS]
            AWS_KMS <---> AZ_KV
            AWS_KMS <---> GCP_KMS
        end
    end

    subgraph OPERATIONS[Security & Business Operations]
        direction TB
        subgraph SIEM[SIEM & Threat Detection]
            SENT[Microsoft Sentinel]
            GD[AWS GuardDuty] --> SENT
            SCC[GCP Security Command Center] --> SENT
            LOGS[DNS & FW Logs] --> SENT
        end

        subgraph DR[Resilience & Disaster Recovery]
            AWS_DR[AWS DR Region]
            AZ_DR[Azure DR Region]
            GCP_DR[GCP DR Region]
        end

        subgraph AI[AI, Analytics & Sustainability]
            KINESIS[AWS Kinesis]
            SYN[Azure Synapse]
            BIGQ[BigQuery]
            VAI[Vertex AI]
            KINESIS --> SYN --> BIGQ --> VAI
        end
    end

    FOUNDATION --> OPERATIONS
```
---

<p align="center">
  <a href="#-volumes-0-8">
    <img src="https://img.shields.io/badge/Start-Volumes%200–8-blue?style=for-the-badge" alt="Start Volumes 0-8"/>
  </a>

  <a href="docs/theory/">
    <img src="https://img.shields.io/badge/Open-Theory%20Library-8A2BE2?style=for-the-badge" alt="Theory Library"/>
  </a>

  <a href="labs/">
    <img src="https://img.shields.io/badge/Launch-Hands--On%20Labs-orange?style=for-the-badge" alt="Hands-On Labs"/>
  </a>

  <a href="diagrams/">
    <img src="https://img.shields.io/badge/View-Architecture%20Diagrams-brightgreen?style=for-the-badge" alt="Architecture Diagrams"/>
  </a>
</p>



📚 Volumes 0–8

Each volume has:

📘 Theory — textbook-style explanation

🧪 Lab — Terraform + scripts

🖼 Diagrams — Mermaid/visuals

📝 Binder — “Errors & Fixes” notes

Vol	Title	Theory	Lab
V0	Foundation	docs/theory/volume0-united-airline-foundation.md	—
V1	Zero-to-Hardened AWS Hub	docs/theory/volume1-zero-to-hardened-aws-hub.md	labs/volume1-aws-hub/
V2	Egress Firewall & Inspection	docs/theory/volume2-egress-inspection.md	labs/volume2-egress-inspection/
V3	Cross-Cloud Network (AWS/Azure/GCP)	docs/theory/volume3-cross-cloud-network.md	labs/volume3-cross-cloud-network/
V4	Identity Federation (Entra → AWS/GCP)	docs/theory/volume4-identity-federation.md	labs/volume4-identity-federation/
V5	Multi-Cloud KMS & Data Security	docs/theory/volume5-data-kms.md	labs/volume5-data-kms/
V6	SIEM & SOAR	docs/theory/volume6-siem-soar.md	labs/volume6-siem-soar/
V7	Resilience & DR	docs/theory/volume7-resilience-dr.md	labs/volume7-resilience-dr/
V8	AI, Analytics & Sustainability	docs/theory/volume8-ai-sustainability.md	labs/volume8-ai-sustainability/
📁 Directory Structure
united-airline-secure-network/
├─ docs/
│  ├─ theory/          # All volume theory chapters
│  ├─ binder/          # (Future) master PDFs
│  └─ architecture/    # Diagrams & mermaid files
├─ labs/
│  ├─ volume1-aws-hub/
│  ├─ volume2-egress-inspection/
│  ├─ volume3-cross-cloud-network/
│  ├─ volume4-identity-federation/
│  ├─ volume5-data-kms/
│  ├─ volume6-siem-soar/
│  ├─ volume7-resilience-dr/
│  └─ volume8-ai-sustainability/
├─ diagrams/
├─ terraform/
└─ docs/branding/securethecloud.png

🔐 Security & Support

See:

SECURITY.md
 – how to responsibly report vulnerabilities

SUPPORT.md
 – how to get help, training, or consulting
(GitHub issues, email channels, response times)

🧠 About

Created by Ola Omoniyi (Olagoldstx)
Founder — SecureTheCloud.dev
Multi-Cloud Security Architect (AWS | Azure | GCP | Kubernetes | Zero-Trust | DevSecOps)

This repository is part of the SecureTheCloud.dev Airline Series — built to be:

A teaching tool

A portfolio centerpiece

A consulting accelerator

A living multi-cloud security reference
