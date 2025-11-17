<p align="center">
  <img src="https://raw.githubusercontent.com/Olagoldstx/united-airline-secure-network/main/docs/branding/securethecloud.png" 
       alt="SecureTheCloud Banner" 
       width="80%"/>
</p>

<p align="center">
---
## 📚 Volumes 0–8

<p align="center"><em>Select a module to jump into the theory or lab.</em></p>

---

### 🧭 **Volume 0 — Foundation**  
#### <img src="https://img.icons8.com/color/48/000000/cloud.png" width="28"/> Cloud Concepts · Airline Digital Basics  
A lightweight intro to multi-cloud, airline digital systems, Zero-Trust, and this entire architecture series.

<p align="center">
  <a href="docs/theory/volume0-united-airline-foundation.md"><img src="https://img.shields.io/badge/📘_Theory-Foundation-blue?style=for-the-badge" /></a>
</p>

---

### 🛡️ **Volume 1 — Zero-to-Hardened AWS Hub**  
#### <img src="https://img.icons8.com/color/48/000000/amazon-web-services.png" width="28"/> AWS · Private VPC · Segmentation  
Build a **private-only hub** with VPC segmentation, DNS controls, and baseline observability (Flow Logs).

<p align="center">
  <a href="docs/theory/volume1-zero-to-hardened-aws-hub.md"><img src="https://img.shields.io/badge/📘_Theory-Zero--to--Hardened_AWS_Hub-blue?style=for-the-badge&logo=amazonaws" /></a>
  <a href="labs/volume1-aws-hub/"><img src="https://img.shields.io/badge/🧪_Lab-AWS_Hub-orange?style=for-the-badge" /></a>
</p>

---

### 🔥 **Volume 2 — Egress Firewall & Deep Inspection**  
#### <img src="https://img.icons8.com/color/48/000000/amazon-web-services.png" width="28"/> AWS · Network Firewall · GWLB  
Centralized egress inspection with AWS Network Firewall, Suricata rules, FQDN allowlists, and DNS filtering.

<p align="center">
  <a href="docs/theory/volume2-egress-inspection.md"><img src="https://img.shields.io/badge/📘_Theory-Egress_Firewall-red?style=for-the-badge&logo=amazonaws" /></a>
  <a href="labs/volume2-egress-inspection/"><img src="https://img.shields.io/badge/🧪_Lab-Egress-orange?style=for-the-badge" /></a>
</p>

---

### 🌍 **Volume 3 — Cross-Cloud Network (AWS ↔ Azure ↔ GCP)**  
#### <img src="https://img.icons8.com/color/48/000000/cloud-network.png" width="28"/> Multi-Cloud Routing · TGW · vWAN · Cloud Router  
Create a private global mesh using IPSec + BGP: AWS TGW ↔ Azure vWAN ↔ GCP Cloud Router.

<p align="center">
  <a href="docs/theory/volume3-cross-cloud-network.md"><img src="https://img.shields.io/badge/📘_Theory-Cross_Cloud_Network-blue?style=for-the-badge&logo=googlecloud" /></a>
  <a href="labs/volume3-cross-cloud-network/"><img src="https://img.shields.io/badge/🧪_Lab-Network-orange?style=for-the-badge" /></a>
</p>

---

### 🔐 **Volume 4 — Identity Federation (Entra → AWS/GCP)**  
#### <img src="https://img.icons8.com/color/48/000000/azure-1.png" width="28"/> Azure Entra ID · SAML · SCIM · OIDC  
Unified workforce identity: Entra SSO → AWS IAM Identity Center + GCP Workforce Identity Federation.

<p align="center">
  <a href="docs/theory/volume4-identity-federation.md"><img src="https://img.shields.io/badge/📘_Theory-Identity_Federation-purple?style=for-the-badge&logo=microsoftazure" /></a>
  <a href="labs/volume4-identity-federation/"><img src="https://img.shields.io/badge/🧪_Lab-Federation-orange?style=for-the-badge" /></a>
</p>

---

### 🔒 **Volume 5 — Multi-Cloud KMS & Data Security**  
#### <img src="https://img.icons8.com/color/48/000000/key-security.png" width="28"/> AWS KMS · Azure Key Vault · GCP KMS  
Unified key hierarchy, envelope encryption, rotation, and data protection across AWS, Azure, and GCP.

<p align="center">
  <a href="docs/theory/volume5-data-kms.md"><img src="https://img.shields.io/badge/📘_Theory-Multi_Cloud_KMS-green?style=for-the-badge&logo=amazonaws" /></a>
  <a href="labs/volume5-data-kms/"><img src="https://img.shields.io/badge/🧪_Lab-KMS-orange?style=for-the-badge" /></a>
</p>

---

### 👁️ **Volume 6 — SIEM & SOAR**
#### <img src="https://img.icons8.com/color/48/000000/monitor--v1.png" width="28"/> Sentinel · GuardDuty · SCC · Automation  
Centralized logging + cross-cloud SIEM + automated response with Logic Apps, AWS API, GCP API.

<p align="center">
  <a href="docs/theory/volume6-siem-soar.md"><img src="https://img.shields.io/badge/📘_Theory-SIEM_&_SOAR-blue?style=for-the-badge&logo=microsoftazure" /></a>
  <a href="labs/volume6-siem-soar/"><img src="https://img.shields.io/badge/🧪_Lab-SOAR-orange?style=for-the-badge" /></a>
</p>

---

### 🌪️ **Volume 7 — Resilience & Disaster Recovery**
#### <img src="https://img.icons8.com/color/48/000000/region-code.png" width="28"/> Multi-Region · Multi-Cloud · Chaos Engineering  
Airline-grade continuity: DNS failover, KMS multi-region replication, cross-cloud DR, chaos testing.

<p align="center">
  <a href="docs/theory/volume7-resilience-dr.md"><img src="https://img.shields.io/badge/📘_Theory-Resilience_&_DR-darkgreen?style=for-the-badge" /></a>
  <a href="labs/volume7-resilience-dr/"><img src="https://img.shields.io/badge/🧪_Lab-DR-orange?style=for-the-badge" /></a>
</p>

---

### 🤖 **Volume 8 — AI, Analytics & Sustainability**
#### <img src="https://img.icons8.com/color/48/000000/artificial-intelligence.png" width="28"/> Vertex AI · BigQuery · Kinesis · Synapse  
Multi-cloud AI pipeline: ingestion → lake → Synapse → BigQuery → Vertex AI + CO₂/fuel analytics.

<p align="center">
  <a href="docs/theory/volume8-ai-sustainability.md"><img src="https://img.shields.io/badge/📘_Theory-AI_&_Sustainability-yellow?style=for-the-badge&logo=googlecloud" /></a>
  <a href="labs/volume8-ai-sustainability/"><img src="https://img.shields.io/badge/🧪_Lab-AI-orange?style=for-the-badge" /></a>
</p>

---

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



## 📚 Volumes 0–8

<p align="center"><em>Your learning roadmap — start here, then explore each volume.</em></p>

---

### 🟢 Start Here — Recommended Path

> **If this is your first time here, follow this flow:**
> 1. Read **V0 – Foundation** (high-level airline + cloud context)  
> 2. Do **V1 – Hardened Hub** lab and validate no public exposure  
> 3. Walk through **V2 + V3** to see how traffic is controlled & routed  
> 4. Then pick identity (V4), data (V5), detection (V6), DR (V7), or AI (V8) based on your focus.

---

<table>
  <tr>
    <td width="50%" valign="top">

      <!-- Column 1: V0–V4 -->

      ### 🧭 Volume 0 — Foundation  
      <sub><img src="https://img.icons8.com/color/48/000000/cloud.png" width="20"/> Cloud Concepts · Airline Model</sub>  
      A lightweight intro to airline digital systems, multi-cloud strategy, Zero-Trust, and how this whole project fits together.

      <p align="center">
        <a href="docs/theory/volume0-united-airline-foundation.md">
          <img src="https://img.shields.io/badge/📘_Theory-Foundation-blue?style=for-the-badge" />
        </a>
      </p>

      ---

      ### 🛡️ Volume 1 — Zero-to-Hardened AWS Hub  
      <sub><img src="https://img.icons8.com/color/48/000000/amazon-web-services.png" width="20"/> AWS · Private VPC · Segmentation</sub>  
      Build a **private-only AWS hub**, segmented into app/data/mgmt, with Flow Logs and DNS ready for future volumes.

      <p align="center">
        <a href="docs/theory/volume1-zero-to-hardened-aws-hub.md">
          <img src="https://img.shields.io/badge/📘_Theory-Zero--to--Hardened_AWS_Hub-blue?style=for-the-badge&logo=amazonaws" />
        </a>
        <a href="labs/volume1-aws-hub/">
          <img src="https://img.shields.io/badge/🧪_Lab-AWS_Hub-orange?style=for-the-badge" />
        </a>
      </p>

      ---

      ### 🔥 Volume 2 — Egress Firewall & Deep Inspection  
      <sub><img src="https://img.icons8.com/color/48/000000/amazon-web-services.png" width="20"/> AWS · Network Firewall · GWLB</sub>  
      Add centralized egress with AWS Network Firewall, Suricata rules, FQDN allow-lists, and DNS filtering.

      <p align="center">
        <a href="docs/theory/volume2-egress-inspection.md">
          <img src="https://img.shields.io/badge/📘_Theory-Egress_Firewall-red?style=for-the-badge&logo=amazonaws" />
        </a>
        <a href="labs/volume2-egress-inspection/">
          <img src="https://img.shields.io/badge/🧪_Lab-Egress-orange?style=for-the-badge" />
        </a>
      </p>

      ---

      ### 🌍 Volume 3 — Cross-Cloud Network (AWS ↔ Azure ↔ GCP)  
      <sub><img src="https://img.icons8.com/color/48/000000/cloud-network.png" width="20"/> TGW · vWAN · Cloud Router</sub>  
      Wire up AWS TGW, Azure vWAN, and GCP Cloud Router using IPSec + BGP to form a private global mesh.

      <p align="center">
        <a href="docs/theory/volume3-cross-cloud-network.md">
          <img src="https://img.shields.io/badge/📘_Theory-Cross_Cloud_Network-blue?style=for-the-badge&logo=googlecloud" />
        </a>
        <a href="labs/volume3-cross-cloud-network/">
          <img src="https://img.shields.io/badge/🧪_Lab-Network-orange?style=for-the-badge" />
        </a>
      </p>

      ---

      ### 🔐 Volume 4 — Identity Federation (Entra → AWS/GCP)  
      <sub><img src="https://img.icons8.com/color/48/000000/azure-1.png" width="20"/> Entra ID · SAML · SCIM · OIDC</sub>  
      Use Microsoft Entra as your single IdP for AWS & GCP: SSO, SCIM provisioning, and workload identity.

      <p align="center">
        <a href="docs/theory/volume4-identity-federation.md">
          <img src="https://img.shields.io/badge/📘_Theory-Identity_Federation-purple?style=for-the-badge&logo=microsoftazure" />
        </a>
        <a href="labs/volume4-identity-federation/">
          <img src="https://img.shields.io/badge/🧪_Lab-Federation-orange?style=for-the-badge" />
        </a>
      </p>

    </td>
    <td width="50%" valign="top">

      <!-- Column 2: V5–V8 -->

      ### 🔒 Volume 5 — Multi-Cloud KMS & Data Security  
      <sub><img src="https://img.icons8.com/color/48/000000/key-security.png" width="20"/> AWS KMS · Key Vault · Cloud KMS</sub>  
      Design a global key hierarchy, apply envelope encryption, and standardize key usage/policy across all three clouds.

      <p align="center">
        <a href="docs/theory/volume5-data-kms.md">
          <img src="https://img.shields.io/badge/📘_Theory-Multi_Cloud_KMS-green?style=for-the-badge&logo=amazonaws" />
        </a>
        <a href="labs/volume5-data-kms/">
          <img src="https://img.shields.io/badge/🧪_Lab-KMS-orange?style=for-the-badge" />
        </a>
      </p>

      ---

      ### 👁️ Volume 6 — SIEM & SOAR  
      <sub><img src="https://img.icons8.com/color/48/000000/monitor--v1.png" width="20"/> Sentinel · GuardDuty · SCC</sub>  
      Centralize telemetry from AWS, Azure, and GCP into a unified SIEM, and automate response with playbooks.

      <p align="center">
        <a href="docs/theory/volume6-siem-soar.md">
          <img src="https://img.shields.io/badge/📘_Theory-SIEM_&_SOAR-blue?style=for-the-badge&logo=microsoftazure" />
        </a>
        <a href="labs/volume6-siem-soar/">
          <img src="https://img.shields.io/badge/🧪_Lab-SOAR-orange?style=for-the-badge" />
        </a>
      </p>

      ---

      ### 🌪️ Volume 7 — Resilience & Disaster Recovery  
      <sub><img src="https://img.icons8.com/color/48/000000/region-code.png" width="20"/> Multi-Region · Multi-Cloud · Chaos</sub>  
      Achieve airline-level uptime via multi-region DR, DNS failover, cross-cloud recovery, and chaos experimentation.

      <p align="center">
        <a href="docs/theory/volume7-resilience-dr.md">
          <img src="https://img.shields.io/badge/📘_Theory-Resilience_&_DR-darkgreen?style=for-the-badge" />
        </a>
        <a href="labs/volume7-resilience-dr/">
          <img src="https://img.shields.io/badge/🧪_Lab-DR-orange?style=for-the-badge" />
        </a>
      </p>

      ---

      ### 🤖 Volume 8 — AI, Analytics & Sustainability  
      <sub><img src="https://img.icons8.com/color/48/000000/artificial-intelligence.png" width="20"/> Vertex AI · BigQuery · Synapse</sub>  
      Build the Airline AI Control Tower: streaming ingestion, lakehouse modeling, ML pipelines, and CO₂ analytics.

      <p align="center">
        <a href="docs/theory/volume8-ai-sustainability.md">
          <img src="https://img.shields.io/badge/📘_Theory-AI_&_Sustainability-yellow?style=for-the-badge&logo=googlecloud" />
        </a>
        <a href="labs/volume8-ai-sustainability/">
          <img src="https://img.shields.io/badge/🧪_Lab-AI-orange?style=for-the-badge" />
        </a>
      </p>

    </td>
  </tr>
</table>

---


---

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
