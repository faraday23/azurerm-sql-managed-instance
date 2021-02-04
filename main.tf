resource "azurerm_resource_group_template_deployment" "sql_mi" {
    name                = "${var.names.product_name}-${var.names.service_name}-${var.vm_settings.name}"
    resource_group_name = var.resource_group_name
    tags                = var.tags
    deployment_mode     = var.deployment_mode
    template_content    = file("${path.module}/sql-managed-instance.json") 
    parameters_content =  jsonencode({
        storage-account-name = {value = "tfdemoarm01"},
    })
}

