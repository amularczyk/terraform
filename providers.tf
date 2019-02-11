provider "azurerm" {
  version = "~> 1.21.0"

  # subscription_id = "c094cbe8-63e9-44f6-8c0e-8ecaff23002d"
  # tenant_id       = "2940c962-d207-447b-93a0-86766a790d35"

  # client_id       = "bfa13f56-554d-4c28-b9fb-42dcddfdc3bf"
  # client_secret   = "YI93GysUSvN7R1zi/8LBrZKzn+ixHyE9ZvJVoVnUhPw="
}

terraform {
  backend "azurerm" {
    storage_account_name = "terraform8"
    container_name = "terraform2"
    resource_group_name = "terraform-state"
    key = "terraform.tfstate"
  }
}

# terraform init -backend-config="backend.tfvars"