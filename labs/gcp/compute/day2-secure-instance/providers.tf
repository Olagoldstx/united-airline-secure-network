
terraform {
  required_providers {
    google = { source = "hashicorp/google", version="~> 5.0" }
  }
}
provider "google" {
  project = "caramel-pager-470614-d1"
  region  = "us-central1"
}
