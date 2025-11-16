# ✈️ United Airline — Volume 4 Lab Guide
# Identity Federation Across AWS, Azure & GCP
SecureTheCloud.dev — Labs Series

This lab implements the **unified identity layer** for United Airline.

You will configure:

- Microsoft Entra ID → AWS IAM Identity Center (SSO)
- SCIM automatic provisioning (users & groups)
- Entra ID → GCP Workforce Identity Federation (WIF)
- Entra ID → AWS OIDC Federation (for workloads)
- Group → Permission Set mapping
- Conditional Access validation
- Multi-cloud CLI login testing

This completes the identity pillar of United Airline’s Zero Trust architecture.

---

# 🧭 1. Lab Objectives

By the end of this lab, you will have:

### ✔ Single Sign-On (SSO) for AWS using Entra ID  
### ✔ AWS SCIM provisioning → automatic user/group sync  
### ✔ GCP Workforce Identity Federation using Entra users  
### ✔ Federated workload identities (OIDC)  
### ✔ Cross-cloud authentication with short-lived tokens  
### ✔ Group-based access RBAC  
### ✔ No long-lived IAM access keys  
### ✔ Conditional Access policies applied to AWS & GCP authentication  

This replaces all IAM users and static credentials with **true passwordless, federated identity**.

---

# 📂 2. Directory Structure

labs/volume4-identity-federation/
│
└── README.md ← (this file)
federation-diagrams/
test-scripts/
terraform/
├── aws-oidc/
├── gcp-wif/
└── azure-scim-config/

yaml
Copy code

---

# 🛠️ 3. Prerequisites

### ✔ Microsoft Entra ID (Azure AD) admin  
### ✔ AWS Organization + IAM Identity Center enabled  
### ✔ GCP Organization + project access  
### ✔ AWS CLI, Azure CLI, gcloud CLI installed  
### ✔ Terraform >= 1.6  

---

# 🔵 PART A — Entra → AWS Identity Center (SSO)

## Step A1 — Enable IAM Identity Center (SSO)

AWS Console → IAM Identity Center  
- Choose **External Identity Provider**  
- Download **AWS SAML metadata** file (`sp-metadata.xml`)

## Step A2 — Register AWS application in Entra

Azure Portal → Entra ID  
- Enterprise Applications → **New Application**  
- Search **AWS IAM Identity Center (Successor to AWS SSO)**  
- Upload AWS metadata (`sp-metadata.xml`)  
- Configure:
  - Entity ID
  - Reply URL
  - Sign-on URL  

## Step A3 — Configure SAML claims

Set:
- NameID → `user.mail`  
- Unique Identifier → `user.mail`  
- Email, givenname, surname  

Save.

## Step A4 — Enable SCIM Provisioning

Still in the AWS Enterprise App:

1. Go to **Provisioning**
2. Set to **Automatic**
3. Provide:
   - SCIM URL (from AWS SSO)
   - SCIM token (from AWS SSO)
4. Test connection → Success

### Result:
Entra automatically creates:
- Users in AWS Identity Center  
- Groups  
- Role assignments  
- Lifecycle sync  

This replaces all manual IAM identity management.

---

# 🟢 PART B — Group → Permission Set Mapping (AWS)

Recommended United Airline mappings:

| Entra Group | AWS Permission Set | Description |
|-------------|--------------------|-------------|
| ua-admins | AdministratorAccess | Cloud admins |
| ua-devops | PowerUserAccess | Engineers |
| ua-security | ViewOnlyAccess + GuardDuty + SecurityAudit | Security posture |
| ua-crew-ops | ReadOnlyAccess | Crew applications |
| ua-contractors | CustomLeastPrivilege | Vendors |

Configure in:
**AWS SSO → AWS Accounts → Assign Users/Groups**

---

# 🔴 PART C — Test AWS SSO Login

From CLI:

```bash
aws sso login --profile united-admin
Browser will open → authenticate via Entra → return token.

Verify identity:

bash
Copy code
aws sts get-caller-identity --profile united-admin
Expected:

ARN references AWS SSO role

No IAM user

No long-lived keys

🟡 PART D — Entra → GCP Workforce Identity Federation (WIF)
Step D1 — Create Workforce Pool
GCP Console → IAM
Identity Federation → Workforce Pools → Create

Name:

Copy code
united-airline-workforce
Provider type: OpenID Connect (OIDC)
Issuer URL:

bash
Copy code
https://login.microsoftonline.com/<TENANT_ID>/v2.0
Step D2 — Configure allowed claims
Example:

email

groups

name

tid (tenant ID)

Step D3 — Map Entra users → GCP IAM roles
Example:

bash
Copy code
principalSet://iam.googleapis.com/projects/PROJECT_NUMBER/locations/global/workforcePools/united-airline-workforce/group/ua-admins
→ roles/editor
Crew operators:

bash
Copy code
principalSet://.../group/ua-crew-ops
→ roles/viewer
🔵 PART E — Test GCP Federated Login
bash
Copy code
gcloud auth login \
  --workforce-pool="united-airline-workforce" \
  --issuer-uri="https://login.microsoftonline.com/<TENANT_ID>/v2.0"
Validate:

bash
Copy code
gcloud auth list
gcloud projects list
🟣 PART F — Entra → AWS OIDC Federation (Workloads)
This eliminates static access keys in:

GitHub Actions

DevOps pipelines

Azure VMs

AKS/Kubernetes

Serverless workloads

Step F1 — Create AWS OIDC provider (Terraform)
Example Terraform snippet:

hcl
Copy code
resource "aws_iam_openid_connect_provider" "entra" {
  url = "https://login.microsoftonline.com/<TENANT_ID>/v2.0"
  client_id_list = [
    "api://AzureADTokenExchange"
  ]
  thumbprint_list = ["A1B2C3D4E5F6..."]
}
Step F2 — Create federated IAM role
hcl
Copy code
resource "aws_iam_role" "entra_federation" {
  name = "united-airline-entra-oidc-role"
  assume_role_policy = data.aws_iam_policy_document.oidc_assume.json
}
Step F3 — Token exchange
From Entra or Azure workload:

Request JWT

Exchange into AWS temporary credentials

🔐 PART G — Apply Conditional Access Policies
Recommended airline-grade policies:

✔ Require MFA
✔ Block legacy protocols
✔ Block non-compliant devices
✔ Only allow login from trusted locations
✔ Require passwordless for admins
✔ Enforce session risk evaluation
This applies automatically to AWS & GCP logins because both rely on Entra.

🔎 7. Validation Tests
Test 1 — AWS Console SSO Login
✓ Works
✓ Shows Permission Sets
✓ No IAM users

Test 2 — AWS CLI login
✓ aws sso login
✓ get-caller-identity returns federated role

Test 3 — GCP CLI login
✓ gcloud auth login --workforce-pool=...

Test 4 — Workload federation
✓ Azure workload calls AWS STS and gets temporary role

Test 5 — SCIM Sync
✓ Create user in Entra → appears in AWS
✓ Remove user → removed from AWS

Test 6 — Conditional Access
✓ Unauthorized location → login blocked
✓ Clean corporate device → login allowed

🛑 8. Troubleshooting
Issue	Cause	Solution
SSO login fails	Wrong NameID claim	Set NameID → user.mail
SCIM error	Wrong token	Regenerate SCIM secret in AWS
GCP refuses token	Incorrect issuer URL	Must use /v2.0 endpoint
Workload token invalid	Wrong client ID	Use api://AzureADTokenExchange
Permission mismatch	Group not synced	Force SCIM re-sync

📝 9. Binder Notes (Errors & Fixes)
vbnet
Copy code
[2025-xx-xx] SCIM 500 error
Fix: Updated SCIM bearer token.

[2025-xx-xx] AWS CLI login returned incorrect role
Fix: Updated group→permission set mapping.

[2025-xx-xx] GCP login failed
Fix: Added email claim to OIDC provider.
🧠 10. Summary
This lab gave United Airline:

Unified identity across AWS, Azure, and GCP

Conditional Access enforcement in ALL clouds

Short-lived, federated credentials

Automated lifecycle (SCIM)

Secure workload identities

Zero IAM users

Zero static keys

Zero excess permissions

This is the core IAM layer for the rest of the United Airline multi-cloud architecture.
