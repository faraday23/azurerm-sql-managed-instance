# NOTE: For the first instance in a subnet, deployment time is typically much longer than in the case of the subsequent instances and can take up to 6 hours to complete.
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
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0.0"
    }

  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "mi_name" {
  length  = 12
  special = false
  upper   = false
  number  = false
}

# creates random password for admin account 
resource "random_password" "admin" {
  length           = 24
  special          = true
  override_special = "!@#$%^&*"
}

module "subscription" {
  source          = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = "00000000-0000-0000-0000-00000000"
}

module "rules" {
  source = "github.com/[redacted]/terraform-azurerm-naming.git?ref=v1.0.0"
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


# azurerm_sql_managed_instance see for more info https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview
module "sql_mi" {
  source = "github.com/faraday23/azurerm-sql-managed-instance.git"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names


  deployment_mode = "Incremental"

  # Configuration to deploy a SQL Managed Instance 
  sql_mi_settings = {
    sqlManagedInstanceName            = "azuremi-eastus2-sandbox-${random_string.mi_name.result}" # Name of the Azure SQL Managed Instance - must be globally unique, contain only lowercase letters, numbers and '-'"
    sqlManagedInstanceSkuName         = "GP_Gen5"
    sqlManagedInstanceStorageSizeInGB = "32"
    sqlManagedInstancevCores          = "8"
    sqlManagedInstanceLicenseType     = "LicenseIncluded"
    sqlManagedInstanceSkuEdition      = "GeneralPurpose"
    sqlManagedInstanceHardwareFamily  = "Gen5"
    sqlManagedInstanceCollation       = "SQL_Latin1_General_CP1_CI_AS"
    sqlManagedInstanceAdminLogin      = "azadmin"
    sqlManagedInstancePassword        = random_password.admin.result
    tags                              = { "location" : "eastus2", "environment" : "sandbox", "sre_team" : "alpha" }
    "_artifactsLocation"              = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/azure-sql-managed-instance/"
    "_artifactsLocationSasToken"      = ""
    vnetResourceName                  = "virtualNetwork"
    vnetAddressRange                  = "10.0.0.0/16"
    managedInstanceSubnetName         = "mi-subnet"
    managedInstanceNSGName            = "mi-NSG"
    managedInstanceRouteTableName     = "mi-RouteTable"
    managedInstanceSubnetAddressRange = "10.0.0.0/24"
    miManagementIps                   = ["vnetLocalRoute", "13.64.0.0/11", "13.104.0.0/14", "20.33.0.0/16", "20.34.0.0/15", "20.36.0.0/14", "20.40.0.0/13", "20.48.0.0/12", "20.64.0.0/10", "20.128.0.0/16", "20.135.0.0/16", "20.136.0.0/16", "20.140.0.0/15", "20.143.0.0/16", "20.144.0.0/14", "20.150.0.0/15", "20.160.0.0/12", "20.176.0.0/14", "20.180.0.0/14", "20.184.0.0/13", "20.192.0.0/10", "40.64.0.0/10", "51.4.0.0/15", "51.8.0.0/16", "51.10.0.0/15", "51.18.0.0/16", "51.51.0.0/16", "51.53.0.0/16", "51.103.0.0/16", "51.104.0.0/15", "51.132.0.0/16", "51.136.0.0/15", "51.138.0.0/16", "51.140.0.0/14", "51.144.0.0/15", "52.96.0.0/12", "52.112.0.0/14", "52.125.0.0/16", "52.126.0.0/15", "52.130.0.0/15", "52.132.0.0/14", "52.136.0.0/13", "52.145.0.0/16", "52.146.0.0/15", "52.148.0.0/14", "52.152.0.0/13", "52.160.0.0/11", "52.224.0.0/11", "64.4.0.0/18", "65.52.0.0/14", "66.119.144.0/20", "70.37.0.0/17", "70.37.128.0/18", "91.190.216.0/21", "94.245.64.0/18", "103.9.8.0/22", "103.25.156.0/24", "103.25.157.0/24", "103.25.158.0/23", "103.36.96.0/22", "103.255.140.0/22", "104.40.0.0/13", "104.146.0.0/15", "104.208.0.0/13", "111.221.16.0/20", "111.221.64.0/18", "129.75.0.0/16", "131.107.0.0/16", "131.253.1.0/24", "131.253.3.0/24", "131.253.5.0/24", "131.253.6.0/24", "131.253.8.0/24", "131.253.12.0/22", "131.253.16.0/23", "131.253.18.0/24", "131.253.21.0/24", "131.253.22.0/23", "131.253.24.0/21", "131.253.32.0/20", "131.253.61.0/24", "131.253.62.0/23", "131.253.64.0/18", "131.253.128.0/17", "132.245.0.0/16", "134.170.0.0/16", "134.177.0.0/16", "137.116.0.0/15", "137.135.0.0/16", "138.91.0.0/16", "138.196.0.0/16", "139.217.0.0/16", "139.219.0.0/16", "141.251.0.0/16", "146.147.0.0/16", "147.243.0.0/16", "150.171.0.0/16", "150.242.48.0/22", "157.54.0.0/15", "157.56.0.0/14", "157.60.0.0/16", "167.105.0.0/16", "167.220.0.0/16", "168.61.0.0/16", "168.62.0.0/15", "191.232.0.0/13", "192.32.0.0/16", "192.48.225.0/24", "192.84.159.0/24", "192.84.160.0/23", "192.197.157.0/24", "193.149.64.0/19", "193.221.113.0/24", "194.69.96.0/19", "194.110.197.0/24", "198.105.232.0/22", "198.200.130.0/24", "198.206.164.0/24", "199.60.28.0/24", "199.74.210.0/24", "199.103.90.0/23", "199.103.122.0/24", "199.242.32.0/20", "199.242.48.0/21", "202.89.224.0/20", "204.13.120.0/21", "204.14.180.0/22", "204.79.135.0/24", "204.79.179.0/24", "204.79.181.0/24", "204.79.188.0/24", "204.79.195.0/24", "204.79.196.0/23", "204.79.252.0/24", "204.152.18.0/23", "204.152.140.0/23", "204.231.192.0/24", "204.231.194.0/23", "204.231.197.0/24", "204.231.198.0/23", "204.231.200.0/21", "204.231.208.0/20", "204.231.236.0/24", "205.174.224.0/20", "206.138.168.0/21", "206.191.224.0/19", "207.46.0.0/16", "207.68.128.0/18", "208.68.136.0/21", "208.76.44.0/22", "208.84.0.0/21", "209.240.192.0/19", "213.199.128.0/18", "216.32.180.0/22", "216.220.208.0/20", "23.96.0.0/13", "42.159.0.0/16", "51.13.0.0/17", "51.107.0.0/16", "51.116.0.0/16", "51.120.0.0/16", "51.120.128.0/17", "51.124.0.0/16", "102.37.0.0/18", "102.133.0.0/16", "199.30.16.0/20", "204.79.180.0/24"]
  }
}

# output from arm template
output "output_content" {
  value = module.sql_mi.output_content
}

