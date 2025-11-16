# ✈️ United Airline — Volume 8 Lab Guide
# Multi-Cloud AI, Analytics & Sustainability Pipeline (AWS · Azure · GCP)
SecureTheCloud.dev — Labs Series

This lab implements United Airline’s **multi-cloud AI pipeline**, combining:
- AWS for **streaming ingestion**  
- Azure for **enterprise analytics + BI**  
- GCP for **ML training + predictive models**  
- Sustainability & emissions dashboards  
- Secure, private, KMS-encrypted dataflows from Volume 5  
- Governance + observability from Volume 6  

This is the final operational lab in your entire binder series.

---

# 🧭 1) Lab Objectives

By the end of this lab you will deploy:

### ✔ AWS → Kinesis → Glue → S3 landing zones  
### ✔ Azure Synapse → Data Warehouse (bronze → silver → gold)  
### ✔ GCP → BigQuery + Vertex AI MLOps pipeline  
### ✔ Automated multi-cloud data movement  
### ✔ Predictive model (flight delay or baggage delay)  
### ✔ Sustainability metrics (fuel burn + emissions)  
### ✔ Power BI or Looker dashboards  
### ✔ Secure KMS encryption across clouds  
### ✔ Private network connectivity (from Volume 3)  

This establishes the United Airline **AI Control Tower**.

---

# 📂 2) Directory Structure

labs/volume8-ai-sustainability/
│
├─ README.md
└─ terraform/
└─ envs/
├── aws-ingestion/
├── azure-synapse/
└── gcp-vertex/

yaml
Copy code

---

# 🧱 3) PART A — AWS Data Ingestion Layer (Kinesis → S3)

This simulates ingestion of FlightOps data (telemetry, bag scans, weather, bookings).

### Step A1 — Create ingestion environment
```bash
cd labs/volume8-ai-sustainability/terraform/envs/aws-ingestion
Step A2 — providers.tf
hcl
Copy code
provider "aws" {
  region = "us-east-1"
}
Step A3 — main.tf (Kinesis + S3 Lake)
hcl
Copy code
resource "aws_kinesis_stream" "ua_stream" {
  name        = "ua-flightops-stream"
  shard_count = 1
}

resource "aws_s3_bucket" "ua_lake" {
  bucket = "ua-flightops-lake"
}

resource "aws_glue_catalog_database" "ua_db" {
  name = "ua_flightops_db"
}

resource "aws_glue_job" "ua_etl" {
  name     = "ua-flightops-etl"
  role_arn = "arn:aws:iam::764265373335:role/ua-glue-role"
  command {
    script_location = "s3://ua-script-bucket/flightops-etl.py"
  }
}
Step A4 — Apply
bash
Copy code
terraform init
terraform apply
Step A5 — Simulate inbound events
pgsql
Copy code
aws kinesis put-record \
  --stream-name ua-flightops-stream \
  --data "aircraft=UA100,fuel=1800lbs,weather=storm" \
  --partition-key 001
Step A6 — ETL job outputs
Glue writes normalized CSV/Parquet files to:

arduino
Copy code
s3://ua-flightops-lake/bronze/
s3://ua-flightops-lake/silver/
These files feed Azure and GCP pipelines.

🔷 4) PART B — Azure Analytics (Synapse + Power BI)
Azure performs:

Warehouse modeling

Business logic

Sustainability dashboards

Step B1 — Create Synapse workspace
Directory:

bash
Copy code
cd labs/volume8-ai-sustainability/terraform/envs/azure-synapse
main.tf

hcl
Copy code
resource "azurerm_synapse_workspace" "ua_synapse" {
  name                                 = "ua-synapse"
  resource_group_name                  = "ua-ai-rg"
  location                             = "eastus2"
  storage_data_lake_gen2_filesystem_id = "/subscriptions/501c458a-5def-42cf-bbb8-c75078c1cdbc/resourceGroups/ua-ai-rg/providers/Microsoft.Storage/storageAccounts/uadatalake/fileSystems/ua"
}
Step B2 — Linked S3 → Synapse via DataFlows
Use:

Azure Data Factory integration or

Synapse Pipelines

Map:

nginx
Copy code
raw      → bronze
bronze   → silver
silver   → gold
Step B3 — Power BI Sustainability Dashboard
Dataset fields:

Metric	Source
Fuel Burn / Flight	Kinesis → Glue → Synapse
CO2 Emissions	Computed from ICAO formula
Taxi Time	FlightOps telemetry
Weather Delay Probability	ML model
Engine Efficiency Index	Vertex AI output

Dashboard includes:

Emissions trend

Aircraft tail-number comparison

Fuel burn efficiency

Delay heatmaps

🟡 5) PART C — GCP AI / ML (BigQuery → Vertex AI)
This section builds the machine learning engine.

Step C1 — Deploy environment
bash
Copy code
cd labs/volume8-ai-sustainability/terraform/envs/gcp-vertex
Step C2 — providers.tf
hcl
Copy code
provider "google" {
  region  = "us-central1"
  project = "caramel-pager-470614-d1"
}
Step C3 — BigQuery Dataset
hcl
Copy code
resource "google_bigquery_dataset" "ua_ml" {
  dataset_id = "ua_airline_ml"
  location   = "US"
}
Step C4 — Load Data from AWS Lake → BigQuery
Use:

Transfer Service OR

Cloud Storage Transfer OR

BigQuery federation with S3 (via AWS PrivateLink + connector)

Step C5 — ML Training (BigQuery ML example)
sql
Copy code
CREATE OR REPLACE MODEL `ua_airline_ml.delay_model`
OPTIONS(model_type='logistic_reg') AS
SELECT
  weather,
  fuel,
  taxi_time,
  atc_delay,
  destination,
  delayed
FROM `ua_airline_ml.flightops_silver`;
Step C6 — Vertex AI Pipeline
Vertex AI pipeline DAG:

mathematica
Copy code
Ingest → Clean → Feature Engineering → Train → Evaluate → Register Model → Deploy
Deployment target:

Cloud Run

GKE

AWS EKS (optional multi-cloud model hosting)

Step C7 — Test Prediction
sql
Copy code
SELECT
  *
FROM
  ML.PREDICT(MODEL `ua_airline_ml.delay_model`,
  (SELECT * FROM `ua_airline_ml.flightops_silver` LIMIT 20));
🌱 6) Sustainability & Emissions Analytics Implementation
United Airline uses ICAO fuel/emissions models.

Step S1 — Calculating CO2 Emissions
Formula:

ini
Copy code
CO2 = Fuel_Burn_kg × 3.16
Step S2 — Create Sustainability Table
sql
Copy code
CREATE TABLE `ua_airline_ml.sustainability_metrics` AS
SELECT
  tail_number,
  fuel_burn_kg,
  taxi_time,
  (fuel_burn_kg * 3.16) AS co2_emissions,
  timestamp
FROM `ua_airline_ml.flightops_silver`;
Step S3 — Visualize in Power BI or Looker
Charts:

CO2 per flight

CO2 per route

CO2 anomaly detection

Tail efficiency comparison

🔐 7) Security Controls (Inherited from Volumes 1–6)
All data flows use private cross-cloud networks (Volume 3)

All ML data encrypted with KMS/KV/Cloud KMS (Volume 5)

All identities validated via Entra ID federation (Volume 4)

All AI logs feed Sentinel SIEM (Volume 6)

All environments covered by firewall allowlists (Volume 2)

Secure AI is non-negotiable.

🧪 8) Validation Tests
Test A — Kinesis Ingestion
arduino
Copy code
aws kinesis put-record ...
aws s3 ls s3://ua-flightops-lake/bronze/
Test B — Synapse Transformation
css
Copy code
SELECT TOP 20 * FROM silver.flightops;
Test C — Model Training
sql
Copy code
SELECT * FROM ML.EVALUATE(MODEL `ua_airline_ml.delay_model`);
Test D — Sustainability Values
pgsql
Copy code
SELECT * FROM ua_airline_ml.sustainability_metrics LIMIT 20;
Test E — Power BI Dashboard
Confirm sustainability metrics appear.

🛑 9) Troubleshooting
Issue	Cause	Fix
S3 → Azure dataflow fails	Cross-cloud routing block	Add egress allowlists
BigQuery load fails	Storage connector missing permission	Grant storage.objectViewer
Vertex AI cannot access data	SA lacks bigquery.dataViewer	Assign BigQuery roles
Power BI refresh fails	OAuth token expired	Renew token or use Service Principal

📝 10) Binder — Errors & Fixes
pgsql
Copy code
[2025-xx-xx] Vertex AI pipeline failed  
Fix: Enabled Workload Identity; added BigQuery role.

[2025-xx-xx] Synapse couldn’t read from AWS S3.  
Fix: Updated firewall; configured managed identity.

[2025-xx-xx] Sustainability metric incorrect  
Fix: Corrected ICAO factor; verified kg vs lbs conversion.
🧠 11) Summary
You just built the United Airline AI Control Tower:

Multi-cloud ML pipelines

Predictive maintenance AI

Flight delay prediction

Baggage routing optimization

Fuel burn & emissions analytics

Power BI sustainability dashboards

Secure, KMS-encrypted dataflows

MLOps automation

Enterprise-grade resiliency

This final volume transforms United Airline from secure → smart, predictive, and sustainable.
