✈️ United Airline — Volume 5 Lab Guide
Multi‑Cloud Data Security & KMS Federation (AWS · Azure · GCP)

SecureTheCloud.dev — Labs Series

This lab implements the United Airline data‑security layer across the three clouds: AWS KMS, Azure Key Vault (and/or Managed HSM), and GCP Cloud KMS.
You’ll stand up a consistent key hierarchy, rotation policies, least‑privilege access, and run CLI encryption tests. All traffic must respect the egress firewall from Volume 2.

🧭 1) Objectives

By the end you will have:

A consistent key hierarchy in AWS, Azure, and GCP (env → service → data).

Automatic key rotation (90 days) across clouds.

Least‑privilege policies separating Admins (manage keys) from Apps (use keys).

CLI encryption/decryption tests proving the setup.

Logging enabled (CloudTrail, Azure Monitor, Cloud Audit Logs).

Egress allow‑lists updated to permit only KMS endpoints.

🧱 2) Pre‑reqs (use your real IDs)

AWS Account ID: 764265373335

Azure Tenant ID: 776f9ea5-7add-469d-bc51-8e855e9a1d26

Azure Subscription ID: 501c458a-5def-42cf-bbb8-c75078c1cdbc

GCP Project ID: caramel-pager-470614-d1

GCP Project Number: 973064685337

Tools

Terraform ≥ 1.6

AWS CLI v2, Azure CLI, gcloud

jq (for output parsing, optional)

From earlier volumes

V1: AWS Hub VPC (private‑only)

V2: Centralized egress firewall (allow only KMS endpoints you use)

V3: Cross‑cloud private routing (optional but recommended)

📁 3) Lab Structure

Create the directories (if they don’t exist):

mkdir -p labs/volume5-data-kms/terraform/envs/{aws-kms,azure-kv,gcp-kms}
mkdir -p labs/volume5-data-kms/test-scripts


Tree:

labs/volume5-data-kms/
├─ README.md          ← this file
├─ terraform/
│  └─ envs/
│     ├─ aws-kms/
│     ├─ azure-kv/
│     └─ gcp-kms/
└─ test-scripts/

🧬 4) Key Hierarchy & Naming (standardize now)

Use this global naming to avoid drift:

Level 1 (Environment Master): ua-<env>-master
e.g., ua-prod-master, ua-nonprod-master

Level 2 (Service Keys): ua-<service>-<env>-key
e.g., ua-passenger-prod-key, ua-loyalty-nonprod-key

Aliases / Versions: keep the same names across clouds.

Rotation: 90 days in all clouds.

🔵 5) AWS KMS — Terraform (env: labs/volume5-data-kms/terraform/envs/aws-kms)

providers.tf

terraform {
  required_version = ">= 1.6.0"
  required_providers { aws = { source = "hashicorp/aws", version = ">= 5.55.0" } }
}
provider "aws" { region = var.region }


variables.tf

variable "region" { type = string, default = "us-east-1" }
variable "env"    { type = string, default = "prod" }
variable "service_names" {
  type    = list(string)
  default = ["passenger", "loyalty", "billing"]
}


kms.tf

# Level 1: Environment Master
resource "aws_kms_key" "env_master" {
  description             = "UA ${var.env} master key"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation     = true             # 1-year native AWS; we schedule 90d at L2
  tags = { env = var.env, owner = "united" }
}

resource "aws_kms_alias" "env_master_alias" {
  name          = "alias/ua-${var.env}-master"
  target_key_id = aws_kms_key.env_master.key_id
}

# Level 2: Service keys (90d rotation via external process; native is 1y)
resource "aws_kms_key" "svc" {
  for_each                 = toset(var.service_names)
  description              = "UA ${each.key} ${var.env} key"
  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  enable_key_rotation      = true
  tags = { env = var.env, service = each.key, owner = "united" }
}

resource "aws_kms_alias" "svc_alias" {
  for_each     = aws_kms_key.svc
  name         = "alias/ua-${each.key}-${var.env}-key"
  target_key_id = each.value.key_id
}

# Example: least-privilege key policy attachment for an app role
# Replace "united-app-role" with your SSO-provisioned role ARN.
data "aws_iam_policy_document" "svc_use_policy" {
  statement {
    sid     = "AllowEncryptDecrypt"
    effect  = "Allow"
    actions = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey*","kms:DescribeKey"]
    resources = [for k in aws_kms_key.svc : k.arn]
    principals { type = "AWS", identifiers = ["arn:aws:iam::764265373335:role/united-app-role"] }
  }
}

resource "aws_kms_key_policy" "svc_attach" {
  for_each = aws_kms_key.svc
  key_id   = each.value.key_id
  policy   = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ADMIN group (no decrypt)
      {
        "Sid": "AdminNoDecrypt",
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::764265373335:role/united-kms-admin" },
        "Action": ["kms:Describe*", "kms:EnableKey","kms:DisableKey","kms:ScheduleKeyDeletion","kms:CancelKeyDeletion","kms:CreateAlias","kms:DeleteAlias"],
        "Resource": "*"
      },
      # App role can encrypt/decrypt
      {
        "Sid": "AppUse",
        "Effect": "Allow",
        "Principal": { "AWS": "arn:aws:iam::764265373335:role/united-app-role" },
        "Action": ["kms:Encrypt","kms:Decrypt","kms:GenerateDataKey*","kms:DescribeKey"],
        "Resource": "*"
      }
    ]
  })
}


Run

cd labs/volume5-data-kms/terraform/envs/aws-kms
terraform init && terraform apply


Test (AWS CLI)

PLAINTEXT="UnitedAirline-Test"
KEY_ID=$(aws kms describe-key --key-id alias/ua-passenger-prod-key --query KeyMetadata.KeyId --output text)

# Encrypt
ENC=$(aws kms encrypt \
  --key-id "$KEY_ID" \
  --plaintext "$(echo -n "$PLAINTEXT" | base64)" \
  --query CiphertextBlob --output text)

# Decrypt
aws kms decrypt --ciphertext-blob "$ENC" --query Plaintext --output text | base64 -d && echo


Expected: prints UnitedAirline-Test.
Logs: CloudTrail → KMS events.

🟣 6) Azure Key Vault / Managed HSM — Terraform (env: labs/volume5-data-kms/terraform/envs/azure-kv)

For application‑level envelope encryption, Key Vault typically wraps/unwraps DEKs.
For simple CLI demo we’ll use RSA‑OAEP “encrypt/decrypt”. For symmetric AES at HSM, use Managed HSM (oct-HSM), but CLI examples vary—keep demo RSA.

providers.tf

terraform {
  required_providers { azurerm = { source = "hashicorp/azurerm", version = ">= 3.114.0" } }
}
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}


variables.tf

variable "tenant_id"       { type = string, default = "776f9ea5-7add-469d-bc51-8e855e9a1d26" }
variable "subscription_id" { type = string, default = "501c458a-5def-42cf-bbb8-c75078c1cdbc" }
variable "location"        { type = string, default = "eastus2" }
variable "env"             { type = string, default = "prod" }
variable "rg_name"         { type = string, default = "rg-ua-kms-prod" }
variable "kv_name"         { type = string, default = "ua-kv-prod" }
variable "app_object_id"   { type = string } # Entra Service Principal objectId for app
variable "admin_object_id" { type = string } # Entra Group/ID for KMS admins


main.tf

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = { env = var.env, owner = "united" }
}

resource "azurerm_key_vault" "kv" {
  name                        = var.kv_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"      # for HSM use "premium" or Managed HSM
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  public_network_access_enabled = false
  tags = { env = var.env, owner = "united" }
}

# Admins (no decrypt in prod data flows if you prefer strict SoD)
resource "azurerm_key_vault_access_policy" "admin" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.admin_object_id
  key_permissions = ["Get","List","Create","Delete","GetRotationPolicy","SetRotationPolicy","Update"]
}

# App identity — allowed to use keys
resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = var.tenant_id
  object_id    = var.app_object_id
  key_permissions = ["Get","List","Encrypt","Decrypt","WrapKey","UnwrapKey"]
}

# Service keys (RSA for demo; for envelope wrapping real DEKs)
resource "azurerm_key_vault_key" "svc" {
  for_each            = toset(["passenger","loyalty","billing"])
  name                = "ua-${each.key}-${var.env}-key"
  key_vault_id        = azurerm_key_vault.kv.id
  key_type            = "RSA"
  key_size            = 2048
  key_opts            = ["encrypt","decrypt","wrapKey","unwrapKey"]
}

# Rotation policy (90 days)
resource "azurerm_key_vault_key_rotation_policy" "svc_rot" {
  for_each     = azurerm_key_vault_key.svc
  key_id       = each.value.id
  expire_after        = "P90D"
  notify_before_expiry = "P7D"
  automatic {
    time_after_creation = "P90D"
  }
}


Run

cd labs/volume5-data-kms/terraform/envs/azure-kv
terraform init && terraform apply \
  -var="app_object_id=<YOUR_APP_SP_OBJECT_ID>" \
  -var="admin_object_id=<YOUR_ADMIN_GROUP_OBJECT_ID>"


Test (Azure CLI, RSA‑OAEP)

KV_NAME="ua-kv-prod"
KEY_NAME="ua-passenger-prod-key"
PLAINTEXT="UnitedAirline-Test"

# encrypt
ENC64=$(az keyvault key encrypt \
  --vault-name "$KV_NAME" \
  --name "$KEY_NAME" \
  --algorithm RSA-OAEP \
  --value "$(echo -n "$PLAINTEXT" | base64)" \
  --query result --output tsv)

# decrypt
az keyvault key decrypt \
  --vault-name "$KV_NAME" \
  --name "$KEY_NAME" \
  --algorithm RSA-OAEP \
  --value "$ENC64" \
  --query result --output tsv | base64 -d && echo


Expected: prints UnitedAirline-Test.
Logs: Azure Monitor / Key Vault audit.

Note: For symmetric AES keys and high‑assurance envelopes, use Managed HSM (az keyvault mhsm) and grant wrapKey/unwrapKey to apps; apps generate DEKs locally then wrap with the HSM key (envelope).

🟡 7) GCP Cloud KMS — Terraform (env: labs/volume5-data-kms/terraform/envs/gcp-kms)

providers.tf

terraform {
  required_providers { google = { source = "hashicorp/google", version = ">= 5.0.0" } }
}
provider "google" {
  project = var.project_id
  region  = var.region
}


variables.tf

variable "project_id" { type = string, default = "caramel-pager-470614-d1" }
variable "location"   { type = string, default = "us-central1" }
variable "env"        { type = string, default = "prod" }


kms.tf

resource "google_kms_key_ring" "ua" {
  name     = "ua-${var.env}-ring"
  location = var.location
}

resource "google_kms_crypto_key" "svc" {
  for_each         = toset(["passenger","loyalty","billing"])
  name             = "ua-${each.key}-${var.env}-key"
  key_ring         = google_kms_key_ring.ua.id
  purpose          = "ENCRYPT_DECRYPT"
  rotation_period  = "7776000s" # 90d
  version_template { algorithm = "GOOGLE_SYMMETRIC_ENCRYPTION" }
}

# Example IAM: grant app service account "encrypter/decrypter"
# Replace serviceAccount:ua-app@caramel-pager-470614-d1.iam.gserviceaccount.com
resource "google_kms_crypto_key_iam_binding" "app_use" {
  for_each   = google_kms_crypto_key.svc
  crypto_key_id = each.value.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members       = ["serviceAccount:ua-app@caramel-pager-470614-d1.iam.gserviceaccount.com"]
}


Run

cd labs/volume5-data-kms/terraform/envs/gcp-kms
terraform init && terraform apply


Test (gcloud)

PLAINTEXT="UnitedAirline-Test"
echo -n "$PLAINTEXT" > /tmp/plain.txt

# Encrypt
gcloud kms encrypt \
  --project "caramel-pager-470614-d1" \
  --location "us-central1" \
  --keyring "ua-prod-ring" \
  --key "ua-passenger-prod-key" \
  --plaintext-file=/tmp/plain.txt \
  --ciphertext-file=/tmp/plain.txt.enc

# Decrypt
gcloud kms decrypt \
  --project "caramel-pager-470614-d1" \
  --location "us-central1" \
  --keyring "ua-prod-ring" \
  --key "ua-passenger-prod-key" \
  --ciphertext-file=/tmp/plain.txt.enc \
  --plaintext-file=/tmp/plain.txt.dec

cat /tmp/plain.txt.dec && echo


Expected: prints UnitedAirline-Test.
Logs: Cloud Audit Logs → KMS.

🔐 8) Separation of Duties (SoD) — enforce now

KMS Admins: can create/disable/delete keys, set rotation, view logs. Cannot decrypt production data.

App Roles / Service Accounts: can Encrypt/Decrypt/GenerateDataKey (AWS) or Encrypt/Decrypt/Wrap/Unwrap (Azure), or EncrypterDecrypter (GCP). Cannot manage keys.

This mirrors airline vaults: key custodians ≠ people opening vault contents.

🌐 9) Egress Firewall — update allow‑lists (Volume 2)

Ensure your centralized egress only allows:

AWS: kms.<region>.amazonaws.com

Azure: *.vault.azure.net, *.managedhsm.azure.net (if using MHSM)

GCP: cloudkms.googleapis.com

Block everything else by default.

🔎 10) Validation Checklist

 Keys exist with correct names in all clouds

 Rotation set to ~90 days (AWS native shows 1y; L2 DEK rotation handled by app)

 Admins cannot decrypt production ciphertexts

 Apps can encrypt/decrypt only with their service key

 Logs show key usage events in each cloud

 Firewall only allows KMS endpoints

 No plaintext stored in buckets/DBs (scan if possible)

🛑 11) Troubleshooting
Symptom	Likely Cause	Fix
AWS AccessDeniedException on decrypt	Role not in key policy	Add role to key policy with kms:Decrypt
Azure encrypt works but decrypt fails	Wrong key_opts or CA policy	Ensure encrypt/decrypt opts and app access policy
GCP “PERMISSION_DENIED”	SA missing role	Add roles/cloudkms.cryptoKeyEncrypterDecrypter
Rotation not applying	Wrong resource	Use key rotation resources (Azure policy, GCP rotation_period)
CLI cannot reach KMS	Egress firewall blocking	Add FQDNs listed above
Admin can decrypt in prod	SoD misapplied	Remove decrypt from admin role/policy
📝 12) Binder — Errors & Fixes (fill during lab)
[2025-xx-xx] AWS decrypt failed for app role.
Fix: Added role to KMS key policy with Encrypt/Decrypt/GenerateDataKey.

[2025-xx-xx] Azure CLI decrypt error "Forbidden".
Fix: Added access policy for SP; verified key_opts includes decrypt.

[2025-xx-xx] GCP encrypt worked, decrypt failed.
Fix: SA lacked Decrypter; added EncrypterDecrypter role binding.

🧠 13) Summary

You just implemented United Airline’s multi‑cloud data security:

Consistent key hierarchy across AWS, Azure, and GCP

Rotation & lifecycle controls

Strict SoD and least privilege

Egress filtered to KMS only

End‑to‑end tests and logs

This unlocks secure PII/PCI/flight‑ops encryption everywhere and sets up Volumes 6 (SIEM & SOAR) and 7 (Resilience & DR).
