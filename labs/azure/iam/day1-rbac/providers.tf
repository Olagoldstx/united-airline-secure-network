
terraform {
  required_providers {
    azurerm = { source = "hashicorp/azurerm", version="~> 3.116" }
  }
}
provider "azurerm" {
  features { }
  # CI OIDC envs:
  # ARM_TENANT_ID=776f9ea5-7add-469d-bc51-8e855e9a1d26
  # ARM_SUBSCRIPTION_ID=501c458a-5def-42cf-bbb8-c75078c1cdbc
  # ARM_CLIENT_ID=<YOUR-APP-REG-CLIENT-ID>
}
variable "location" { default = "eastus" }
variable "project"  { default = "stc" }
