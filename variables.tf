# Required parameters
variable "resource_group_name" {
  description = "name of the resource group to create the resource"
  type        = string
}

variable "names" {
  description = "names to be applied to resources"
  type        = map(string)
}

variable "location" {
  description = "Specifies the supported Azure location to MySQL server resource"
  type        = string
}

variable "deployment_mode" {
  description = "(Required) The Deployment Mode for this Resource Group Template Deployment. Possible values are Complete (where resources in the Resource Group not specified in the ARM Template will be destroyed) and Incremental (where resources are additive only)."
  type        = string
  default     = "Incremental"
}

variable "sql_mi_settings" {
  type        = any
  description = "these values are declared on the module call"
}

variable "sql_mi_defaults" {
  type = any
  default = {
    sqlManagedInstanceName            = ""
    location                          = ""
    sqlManagedInstanceSkuName         = "GP_Gen5"
    sqlManagedInstanceStorageSizeInGB = "32"
    sqlManagedInstancevCores          = "8"
    sqlManagedInstanceLicenseType     = "LicenseIncluded"
    sqlManagedInstanceSkuEdition      = "GeneralPurpose"
    sqlManagedInstanceHardwareFamily  = "Gen5"
    sqlManagedInstanceCollation       = "SQL_Latin1_General_CP1_CI_AS"
    sqlManagedInstanceAdminLogin      = "azadmin"
    sqlManagedInstancePassword        = ""
    backupShortTermRetentionPolicies  = "7"
    azureAdAdmin                      = ""
    storageAccountType                = "GRS"
    zoneRedundant                     = "false"
    timezoneId                        = "EST"
    publicDataEndpointEnabled         = "false"
    proxyOverride                     = "Proxy"
    minimalTlsVersion                 = "1.2"
    maintenanceConfigurationId        = ""
    tags                              = {}
    "_artifactsLocation"              = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/azure-sql-managed-instance/"
    "_artifactsLocationSasToken"      = ""
    vnetResourceName                  = "virtualNetwork"
    vnetAddressRange                  = "10.0.0.0/16"
    managedInstanceSubnetName         = "mi-subnet"
    managedInstanceNSGName            = "mi-NSG"
    managedInstanceRouteTableName     = "mi-RouteTable"
    managedInstanceSubnetAddressRange = "10.0.0.0/24"
    miManagementIps                   = []
  }
  description = <<EOT
azure sql managed instance settings (only applied to virtual machine settings managed within this module)
    sqlManagedInstanceName             = (Required) The name of the Managed Instance.
    location                           = (Required) The location of the Managed Instance
    sqlManagedInstanceSkuName          = (Required) Managed instance SKU. If SKU is not set, skuEdition and hardwareFamily values have to be populated. allowedValues: GP_Gen4, GP_Gen5, BC_Gen4, BC_Gen5"
    sqlManagedInstanceStorageSizeInGB  = (Required) Determines how much Storage size in GB to associate with instance. Increments of 32 GB allowed only. minimumValue: 32.
    sqlManagedInstancevCores           = (Required) The number of vCores. allowedValues: 4, 8, 16, 24, 32, 40, 64, 80
    sqlManagedInstanceLicenseType      = (Optional) Determines license pricing model. Select 'LicenseIncluded' for a regular price inclusive of a new SQL license. Select 'Base Price' for a discounted AHB price for bringing your own SQL licenses.
    sqlManagedInstanceHardwareFamily   = (Optional) Compute generation for the instance. Gen4, Gen5
    sqlManagedInstanceCollation        = (Optional) Collation of the Managed Instance.
    timezoneId                         = (Optional) Id of the timezone. Allowed values are timezones supported by Windows.
    proxyOverride                      = (Optional) Determines connection type for private endpoint. Proxy connection type enables proxy connectivity to Managed Instance. Redirect mode enables direct connectivity to the instance resulting in improved latency and throughput. allowedValues: Proxy, Redirect.
    publicDataEndpointEnabled          = (Optional) Determines whether public data endpoint will be enabled, required for clients outside of the connected virtual networks. Public endpoint will always default to Proxy connection mode.
    nsgForPublicEndpoint               = (Optional) Determines whether which NSG inbound traffic rule to add for the public endpoint. In case publicDataEndpointEnabled is false this parameter is ignored. allowedValues: "", allowFromInternetTo3342NSG, allowFromAzureCloudTo3342NSG, disallowTrafficTo3342NSG.
    minimalTlsVersion                  = (Required) The minimum TLS version enforced by the Managed Instance for inbound connections. allowedValues: 1.0, 1.1, 1.2"
    sqlManagedInstanceAdminLogin       = (Required) The login of the Managed Instance admin.
    sqlManagedInstancePassword         = (Required) The password of the Managed Instance admin.
    backupShortTermRetentionPolicies   = (Optional) SQL managed instances are backed up automatically. Backup availability is listed below for each database on this managed instance. Manage your available long-term retention (LTR) backups here. available values: retentionDays: 7-35
    maintenanceConfigurationId         = (Optional) Maintenance window ID. Please note that during a maintenance event, databases are fully available and accessible but some of the maintenance updates require a failover as Azure takes databases offline for a short time to apply the maintenance updates. for more info see https://docs.microsoft.com/en-us/azure/azure-sql/database/maintenance-window"
    managedInstanceTags                = (Optional) Resource tags to associate with the instance. example: { "<tag-name1>": "<tag-value1>", "<tag-name2>": "<tag-value2>" },
    storageAccountType                 = (Required) Option for configuring backup storage redundancy. Selecting 'GRS' will enable 'RA-GRS'. allowedValues: GRS, ZRS, LRS"
    virtualNetworkName                 = (Required) The virtual network name. Leave empty for the default value.
    virtualNetworkResourceGroupName    = (Required) The resource group where the networking resources will be created or updated. Default is the same resource group as Managed Instance.
    defaultVirtualNetworkAddressPrefix = (Optional) The default virtual network address is "10.0.0.0/16"
    defaultSubnetAddressPrefix         = (Optional) The default subnet address is "10.0.0.0/24"
    deployInExistingSubnet             = (Optional) Determines whether the Managed Instance will be deployed in an existing subnet. Subnet parameters need to be valid if this is set.
    subnetName                         = (Optional) The subnet name. Leave empty for the default value. defaultValue: "ManagedInstance"
EOT 
}

