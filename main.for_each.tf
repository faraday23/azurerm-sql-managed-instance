variable budgets {
  description = "Map of budgets"
  type        = map
  default = {
    project1 = {
      amount    = "2"
      contact   = "tokubica@microsoft.com"
      tagName   = "owner"
      tagValue  = "tokubica@microsoft.com"
      startDate = "2021-01-01"
    },
    project2 = {
      amount    = "5"
      contact   = "tomas@tomas.cz"
      tagName   = "owner"
      tagValue  = "tomas@tomas.cz"
      startDate = "2021-01-01"
    }
  }
}

// Terraform currently does not support creating budget nativelly
// Issue as tracked at https://github.com/terraform-providers/terraform-provider-azurerm/pull/9201
// As workaround we will use ARM template deployment from Terraform

data "local_file" "arm" {
  filename = "arm.json"
}

resource "azurerm_subscription_template_deployment" "budgets" {
  for_each           = var.budgets
  name               = each.key
  location           = "westeurope"
  template_content   = data.local_file.arm.content
  parameters_content = <<PARAMETERS
     {
        "budgetName": {
            "value": "${each.key}"
        },
        "amount": {
            "value": "${each.value.amount}"
        },
        "startDate": {
            "value": "${each.value.startDate}"
        },
        "endDate": {
            "value": "2050-01-01"
        },
        "tagName": {
            "value": "${each.value.tagName}"
        },
        "tagValue": {
            "value": "${each.value.tagValue}"
        },
        "stopAction": {
            "value": "${azurerm_monitor_action_group.stop.id}"
        },
        "deleteAction": {
            "value": "${azurerm_monitor_action_group.delete.id}"
        },
        "contactEmails": {
            "value": [
                "${each.value.contact}"
            ]
        }
    }
    PARAMETERS
}
