// Terraform currently does not support creating azure managed instance nativelly
// Issue as tracked at https://github.com/terraform-providers/terraform-provider-azurerm/issues/1747
// As workaround we can use ARM template deployment from Terraform

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
  name                = "${var.names.environment}-${var.names.location}-${random_string.mi_name.result}"
  resource_group_name = var.resource_group_name
  deployment_mode     = var.deployment_mode
  template_content    = data.local_file.arm_template.content
  parameters_content  = <<PARAMETERS
{
   "sqlManagedInstanceName":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceName, var.sql_mi_defaults.sqlManagedInstanceName)}"
   },
   "location":{
      "value":"${var.location}"
   },
   "sqlManagedInstanceSkuName":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceSkuName, var.sql_mi_defaults.sqlManagedInstanceSkuName)}"
   },
   "sqlManagedInstanceStorageSizeInGB":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceStorageSizeInGB, var.sql_mi_defaults.sqlManagedInstanceStorageSizeInGB)}"
   },
   "sqlManagedInstancevCores":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstancevCores, var.sql_mi_defaults.sqlManagedInstancevCores)}"
   },
   "sqlManagedInstanceLicenseType":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceLicenseType, var.sql_mi_defaults.sqlManagedInstanceLicenseType)}"
   },
   "sqlManagedInstanceSkuEdition":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceSkuEdition, var.sql_mi_defaults.sqlManagedInstanceSkuEdition)}"
   },
   "sqlManagedInstanceHardwareFamily":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceHardwareFamily, var.sql_mi_defaults.sqlManagedInstanceHardwareFamily)}"
   },
   "sqlManagedInstanceCollation":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceCollation, var.sql_mi_defaults.sqlManagedInstanceCollation)}"
   },
   "sqlManagedInstanceAdminLogin":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstanceAdminLogin, var.sql_mi_defaults.sqlManagedInstanceAdminLogin)}"
   },
   "sqlManagedInstancePassword":{
      "value":"${try(var.sql_mi_settings.sqlManagedInstancePassword, var.sql_mi_defaults.sqlManagedInstancePassword)}"
   },
   "tags":{
      "value":${jsonencode(var.sql_mi_settings.tags)}
   },
   "_artifactsLocation":{
      "value":"${try(var.sql_mi_settings._artifactsLocation, var.sql_mi_defaults._artifactsLocation)}"
   },
   "_artifactsLocationSasToken":{
      "value":"${try(var.sql_mi_settings._artifactsLocationSasToken, var.sql_mi_defaults._artifactsLocationSasToken)}"
   },
   "vnetResourceName":{
      "value":"${try(var.sql_mi_settings.vnetResourceName, var.sql_mi_defaults.vnetResourceName)}"
   },
   "vnetAddressRange":{
      "value":"${try(var.sql_mi_settings.vnetAddressRange, var.sql_mi_defaults.vnetAddressRange)}"
   },
   "managedInstanceSubnetName":{
      "value":"${try(var.sql_mi_settings.managedInstanceSubnetName, var.sql_mi_defaults.managedInstanceSubnetName)}"
   },
   "managedInstanceNSGName":{
      "value":"${try(var.sql_mi_settings.managedInstanceNSGName, var.sql_mi_defaults.managedInstanceNSGName)}"
   },
   "managedInstanceRouteTableName":{
      "value":"${try(var.sql_mi_settings.managedInstanceRouteTableName, var.sql_mi_defaults.managedInstanceRouteTableName)}"
   },
   "managedInstanceSubnetAddressRange":{
      "value":"${try(var.sql_mi_settings.managedInstanceSubnetAddressRange, var.sql_mi_defaults.managedInstanceSubnetAddressRange)}"
   },
   "miManagementIps":{
      "value":${jsonencode(var.sql_mi_settings.miManagementIps)}
   }
}
   PARAMETERS
}


