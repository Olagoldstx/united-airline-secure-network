# ✈️ United Airline — Volume 7 Lab Guide
# Multi-Region / Multi-Cloud Resilience & Disaster Recovery (DR)
SecureTheCloud.dev — Labs Series

This lab builds and tests **United Airline’s global resilience architecture**, including:
- Multi-AZ HA
- Multi-Region DR (AWS primary → AWS DR region)
- Multi-Cloud failover (AWS → Azure → GCP)
- DNS-driven failover
- KMS multi-region key access
- Chaos engineering simulations
- DR Runbooks + automation hooks

This is the operational backbone for airline-grade uptime.

---

# 🧭 1) Lab Objectives

By the end of this lab, you will:

### ✔ Deploy a warm-standby DR region (AWS us-west-2)  
### ✔ Enable multi-region routing failover (Route53 → Azure TM → GCP)  
### ✔ Configure cross-region RDS + S3 replicas  
### ✔ Configure multi-region KMS keys  
### ✔ Deploy lightweight DR compute (AutoScaling warm standby)  
### ✔ Deploy Azure AKS + GCP GKE as cloud DR options  
### ✔ Simulate failures using Chaos tools  
### ✔ Validate RTO + RPO targets  
### ✔ Document DR runbooks in binder  

This proves United Airline can survive **cloud outages, region outages, network failures, KMS failures, and identity failures**.

---

# 📂 2) Directory Structure

labs/volume7-resilience-dr/
│
├─ README.md
└─ terraform/
└─ envs/
├── aws-dr/
├── azure-dr/
├── gcp-dr/
└── dns-failover/

pgsql
Copy code

---

# 🌐 3) Parts of the Lab

### **PART A — AWS Multi-Region DR**
- us-east-1 → us-west-2
- RDS Cross-Region Read Replica
- S3 Cross-Region Replication (CRR)
- DR AutoScaling group (capacity = 1)
- Multi-region KMS keys
- Failover tests

### **PART B — Azure DR Cloud Cluster**
- Deploy AKS DR cluster
- Deploy Blob GRS storage
- Prepare for DNS failover
- Validate cross-cloud connectivity (from V3)

### **PART C — GCP DR Cloud Cluster**
- Deploy GKE DR cluster
- Deploy CloudSQL read replica
- Optional: GCS multi-region bucket

### **PART D — Global DNS Failover**
- Route53 Primary → DR Region
- Azure Traffic Manager secondary path
- GCP health-based redirect

### **PART E — Chaos Engineering Scenarios**
- Region failure  
- KMS failure  
- Firewall failure  
- Database corruption  
- Identity outage  
- Network tunnel failure  

---

# 🔵 4) PART A — AWS Multi-Region DR

### Step A1 — Create DR region folder
cd labs/volume7-resilience-dr/terraform/envs/aws-dr

csharp
Copy code

### Step A2 — providers.tf
```hcl
provider "aws" {
  region = var.region
}
Step A3 — variables.tf
hcl
Copy code
variable "region"    { type = string, default = "us-west-2" }
variable "primary"   { type = string, default = "us-east-1" }
variable "app_name"  { type = string, default = "ua-api" }
variable "db_name"   { type = string, default = "ua-rds" }
Step A4 — RDS Cross-Region Replica
hcl
Copy code
resource "aws_db_instance" "dr_replica" {
  identifier              = "${var.db_name}-dr"
  replicate_source_db     = "ua-rds-primary"
  engine                  = "aurora-mysql"
  instance_class          = "db.r6g.large"
  publicly_accessible     = false
  skip_final_snapshot     = true
}
Step A5 — S3 Cross-Region Replication
hcl
Copy code
resource "aws_s3_bucket_replication_configuration" "ua_crr" {
  bucket = "ua-main-bucket"
  role   = aws_iam_role.replication.arn

  rule {
    id     = "ua-crr"
    status = "Enabled"

    destination {
      bucket        = "arn:aws:s3:::ua-dr-bucket"
      storage_class = "STANDARD"
      replication_time {
        status = "Enabled"
      }
    }
  }
}
Step A6 — DR AutoScaling Group (Warm Standby)
hcl
Copy code
resource "aws_autoscaling_group" "dr_asg" {
  name                 = "ua-dr-asg"
  desired_capacity     = 1
  min_size             = 1
  max_size             = 10
  launch_configuration = aws_launch_configuration.dr_lc.name
}
Step A7 — Multi-Region KMS
hcl
Copy code
resource "aws_kms_replica_key" "ua_kms_replica" {
  description               = "Replica for UA passenger-prod-key"
  primary_key_arn          = "arn:aws:kms:us-east-1:764265373335:key/<PRIMARY_KEY_ID>"
  deletion_window_in_days  = 30
}
🔷 5) PART B — Azure DR (AKS + GRS Storage)
Step B1 — Deploy AKS DR cluster
bash
Copy code
cd labs/volume7-resilience-dr/terraform/envs/azure-dr
Minimal example:

hcl
Copy code
resource "azurerm_kubernetes_cluster" "ua_dr_aks" {
  name                = "ua-dr-aks"
  location            = "eastus2"
  resource_group_name = "ua-dr-rg"
  dns_prefix          = "ua-dr"
}
Step B2 — Geo-Redundant Storage
hcl
Copy code
resource "azurerm_storage_account" "ua_grs" {
  name                     = "uadrsagrstore"
  location                 = "eastus2"
  resource_group_name      = "ua-dr-rg"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
Step B3 — Validate cross-cloud connectivity
From Azure VM in AKS VNet:

nginx
Copy code
curl http://ua-api.aws.internal
Should route via multi-cloud tunnels (Volume 3).

🟡 6) PART C — GCP DR (GKE + CloudSQL)
Step C1 — Deploy GKE DR cluster
bash
Copy code
cd labs/volume7-resilience-dr/terraform/envs/gcp-dr
hcl
Copy code
resource "google_container_cluster" "ua_dr" {
  name     = "ua-dr-gke"
  location = "us-central1"
  initial_node_count = 1
}
Step C2 — CloudSQL Read Replica
hcl
Copy code
resource "google_sql_database_instance" "ua_replica" {
  name             = "ua-replica"
  region           = "us-central1"
  master_instance_name = "ua-primary"
  replica_configuration {
    failover_target = true
  }
}
Step C3 — Verify connectivity
nginx
Copy code
curl http://ua-api.aws.internal
🟠 7) PART D — Global DNS Failover
Step D1 — Route53 Failover config
hcl
Copy code
resource "aws_route53_record" "ua_api" {
  zone_id = "<ZONE_ID>"
  name    = "api.united-airline.internal"
  type    = "A"

  set_identifier = "primary"
  failover_routing_policy { type = "PRIMARY" }
  health_check_id = aws_route53_health_check.ua_api.id
  records = ["<PRIMARY_ELB_IP>"]
  ttl = 10
}

resource "aws_route53_record" "ua_api_dr" {
  zone_id = "<ZONE_ID>"
  name    = "api.united-airline.internal"
  type    = "A"

  set_identifier = "secondary"
  failover_routing_policy { type = "SECONDARY" }
  records = ["<DR_ELB_IP>"]
  ttl = 10
}
Step D2 — Azure Traffic Manager (optional secondary path)
Traffic Manager endpoint → AWS DR region → GCP endpoint.

Step D3 — GCP Load Balancer health checks
🧨 8) PART E — Chaos Engineering Scenarios
Scenario 1 — Simulate AWS Region Failure
Use AWS Fault Injection Simulator:

powershell
Copy code
aws fis start-experiment ...
Expected:

DNS → DR region

ASG scales up

RDS failover

Scenario 2 — Simulate KMS Outage
Disable primary key momentarily.

Expected:

Multi-region replica key works

Apps continue to encrypt/decrypt

Scenario 3 — Break Network Firewall
Drop GWLB endpoint.

Expected:

Route tables shift to secondary endpoint

Scenario 4 — Identity Outage
Disable Entra ID primary endpoint.

Expected:

Azure global endpoints take over

AWS CLI SSO tokens still function

GCP WIF fallback

Document results.

📋 9) Validation Tests
Test A — API Failover
Kill primary instance; verify API responds from DR region:

nginx
Copy code
curl http://api.united-airline.internal
Test B — DNS Failover
Check what IP resolves:

csharp
Copy code
nslookup api.united-airline.internal
Test C — Database Failover
Promote replica → confirm queries work.

Test D — Multi-Cloud Failover
Force AWS→Azure:

nginx
Copy code
curl http://api.united-airline.internal
Test E — KMS Multi-Region
Encrypt using DR key:

vbnet
Copy code
aws kms encrypt --key-id alias/ua-passenger-prod-key --region us-west-2 ...
🛑 10) Troubleshooting
Issue	Cause	Fix
DNS not failing over	TTL too high	Reduce TTL to 10s
RDS replica not promoting	Wrong permissions	Add rds:PromoteReadReplica
Traffic not routing to Azure	BGP routes missing	Check tunnels from Volume 3
Multi-region KMS denies decrypt	Replica key not propagated	Recreate replica key
GKE not reachable	Missing firewall rule	Allow AWS VPC CIDRs

📝 11) Binder Notes — Errors & Fixes
pgsql
Copy code
[2025-xx-xx] Failover took > 5 min  
Fix: Reduced DNS TTL; pre-warmed DR ASG.

[2025-xx-xx] KMS decrypt failed in DR  
Fix: Enabled multi-region replica key + updated app role.

[2025-xx-xx] Azure DR did not receive traffic  
Fix: Repaired BGP session in vWAN hub.
🧠 12) Summary
You built and tested a full airline-grade resilience program:

Multi-AZ → Multi-Region → Multi-Cloud

DNS-driven failover

DR replicas of data + compute

Multi-region identity + KMS redundancy

Chaos engineering validation

DR runbooks + automation

United Airline can now survive:

Region outages

Cloud outages

Database corruption

Firewall outages

Identity failures

Network tunnel failures

Your architecture is truly enterprise resilient.
