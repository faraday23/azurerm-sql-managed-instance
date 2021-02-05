// Terraform currently does not support creating azure managed instance nativelly
// Issue as tracked at https://github.com/terraform-providers/terraform-provider-azurerm/issues/1747
// As workaround we will use ARM template deployment from Terraform

# creates random password for admin account 
resource "random_password" "admin" {
  length           = 24
  special          = true
  override_special = "!@#$%^&*"
}

resource "random_string" "mi_name" {
  length  = 4
  special = false
  upper   = false
  number  = false
}

data "local_file" "arm_template" {
  filename = "${path.module}/sql-managed-instance.json"
}

resource "azurerm_resource_group_template_deployment" "sql_mi" {
  name                = "${var.names.product_name}-${var.names.service_name}"
  resource_group_name = var.resource_group_name
  deployment_mode     = var.deployment_mode
  template_content    = data.local_file.arm_template.content
  parameters_content  = <<PARAMETERS
     {
        "managedInstanceName": {
            "value": "${var.names.product_name}-${var.names.service_name}"
        },
        "location": {
            "value": "eastus2"
        },
        "skuName": {
            "value": "Standard_F2"
        },
        "storageSizeInGB": {
            "value": "256"
        },
        "vCores": {
            "value": "8"
        },
        "licenseType": {
            "value": "LicenseIncluded"
        },
        "collation": {
            "value": "SQL_Latin1_General_CP1_CI_AS"
        },
        "timezoneId": {
            "value": "UTC"
        },
        "proxyOverride": {
            "value": "Proxy"
        },
        "publicDataEndpointEnabled": {
            "value": false
        },
        "administratorLogin": {
            "value": "azadmin"
        },
        "administratorLoginPassword": {
            "value": "${random_password.admin.result}"
        },
        "managedInstanceTags": {
            "value": "${var.names.product_name}-${var.names.service_name}"
        },
        "storageAccountType": {
            "value": "GRS"
        },
        "virtualNetworkName": {
            "value": "${var.virtual_network_name}"
        },
        "virtualNetworkResourceGroupName": {
            "value": "${var.resource_group_name}"
        },
    }
    PARAMETERS
}
