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
  default     = "Complete"
}

variable "virtual_network_name" {
  type = any
}

variable sql_mi_defaults {
  type = any
  default = {
    managedInstanceName        = "randomcomputername"
    location                   = "eastus2"
    skuName                    = "Standard_F2"
    storageSizeInGB            = 256
    vCores                     = 8
    licenseType                = "LicenseIncluded"
    collation                  = "SQL_Latin1_General_CP1_CI_AS"
    timezoneId                 = "UTC"
    proxyOverride              = "Proxy"
    publicDataEndpointEnabled  = false
    minimalTlsVersion          = "1.2"
    administratorLogin         = "azadmin"
    administratorLoginPassword = ""
    managedInstanceTags        = ""
    storageAccountType         = "GRS"

  }
  description = <<EOT
azure sql managed instance settings (only applied to virtual machine settings managed within this module)
    managedInstanceName             = (Required) The name of the Managed Instance.
    location                        = (Required) The location of the Managed Instance
    skuName                         = (Required) Managed instance SKU. If SKU is not set, skuEdition and hardwareFamily values have to be populated."
    storageSizeInGB                 = (Required) Determines how much Storage size in GB to associate with instance. Increments of 32 GB allowed only.
    vCores                          = (Required) The number of vCores.
    licenseType                     = (Optional) Determines license pricing model. Select 'LicenseIncluded' for a regular price inclusive of a new SQL license. Select 'Base Price' for a discounted AHB price for bringing your own SQL licenses.
    collation                       = (Optional) Specifies the priority of this Virtual Machine. Possible values are Regular and Spot. Defaults to Regular. Changing this forces a new resource to be created.
    timezoneId                      = (Optional) Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is Deallocate. Changing this forces a new resource to be created. This can only be configured when priority is set to Spot.
    proxyOverride                   = (Optional) Determines connection type for private endpoint. Proxy connection type enables proxy connectivity to Managed Instance. Redirect mode enables direct connectivity to the instance resulting in improved latency and throughput.
    publicDataEndpointEnabled       = (Optional) Determines whether public data endpoint will be enabled, required for clients outside of the connected virtual networks. Public endpoint will always default to Proxy connection mode.
    administratorLogin              = (Required) The login of the Managed Instance admin.
    administratorLoginPassword      = (Required) The password of the Managed Instance admin.
    managedInstanceTags             = (Optional) Resource tags to associate with the instance.
    storageAccountType              = (Required) Option for configuring backup storage redundancy. Selecting 'GRS' will enable 'RA-GRS'.
    virtualNetworkName              = (Required) The virtual network name. Leave empty for the default value.
    virtualNetworkResourceGroupName = (Required) The resource group where the networking resources will be created or updated. Default is the same resource group as Managed Instance.

EOT 
}
