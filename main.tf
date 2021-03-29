// Terraform currently does not support creating azure managed instance nativelly
// Issue as tracked at https://github.com/terraform-providers/terraform-provider-azurerm/issues/1747
// As workaround we can use ARM template deployment from Terraform

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
   "backupShortTermRetentionPolicies":{
      "value":"${try(var.sql_mi_settings.backupShortTermRetentionPolicies, var.sql_mi_defaults.backupShortTermRetentionPolicies)}"
   },
   "azureAdAdmin":{
      "value":"${try(var.sql_mi_settings.azureAdAdmin, var.sql_mi_defaults.azureAdAdmin)}"
   },
   "storageAccountType":{
      "value":"${try(var.sql_mi_settings.storageAccountType, var.sql_mi_defaults.storageAccountType)}"
   },
   "zoneRedundant":{
      "value":"${try(var.sql_mi_settings.zoneRedundant, var.sql_mi_defaults.zoneRedundant)}"
   },
   "timezoneId":{
      "value":"${try(var.sql_mi_settings.timezoneId, var.sql_mi_defaults.timezoneId)}"
   },
   "publicDataEndpointEnabled":{
      "value":"${try(var.sql_mi_settings.publicDataEndpointEnabled, var.sql_mi_defaults.publicDataEndpointEnabled)}"
   },
   "proxyOverride":{
      "value":"${try(var.sql_mi_settings.proxyOverride, var.sql_mi_defaults.proxyOverride)}"
   },
   "minimalTlsVersion":{
      "value":"${try(var.sql_mi_settings.minimalTlsVersion, var.sql_mi_defaults.minimalTlsVersion)}"
   }, 
   "maintenanceConfigurationId":{
      "value":"${try(var.sql_mi_settings.maintenanceConfigurationId, var.sql_mi_defaults.maintenanceConfigurationId)}"
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
