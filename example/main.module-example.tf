# Configure terraform and azure provider
terraform {
  required_version = ">= 0.13.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "vm_name" {
  length  = 4
  special = false
  upper   = false
  number  = false
}

data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

module "subscription" {
  source          = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = "00000000-0000-0000-000000"
}

module "rules" {
  source = "github.com/openrba/terraform-azurerm-naming.git?ref=v1.0.0"
}

module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.4.0"

  naming_rules = module.rules.yaml

  market              = "us"
  project             = "https://gitlab.ins.risk.regn.net/example/"
  location            = "eastus2"
  sre_team            = "iog-core-services"
  environment         = "sandbox"
  product_name        = "azuremi"
  business_unit       = "iog"
  product_group       = "core"
  service_name        = "webesp"
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = "nonprod"
  subnet_type         = "iaas-outbound"
  resource_group_type = "app"
}

module "resource_group" {
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v1.0.0"

  location = module.metadata.location
  names    = module.metadata.names
  tags     = module.metadata.tags
}

module "virtual_network" {
  source = "github.com/Azure-Terraform/terraform-azurerm-virtual-network.git?ref=v2.3.1"

  naming_rules = module.rules.yaml

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  address_space = ["10.1.1.0/24"]

  subnets = {
    "iaas-outbound" = { cidrs = ["10.1.1.0/27"]
      service_endpoints   = ["Microsoft.SQL"]
      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
  }
}

# azurerm_sql_managed_instance see for more info https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
module "sql_mi" {
  source = "github.com/faraday23/azurerm-sql-managed-instance.git"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names

  deployment_mode      = "Complete"
  virtual_network_name = module.virtual_network.subnet_nsg_names["iaas-outbound"]
}

# output from arm template
output "output_content" {
  value = module.sql_mi.output_content
}



