
resource "azurerm_resource_group" "rgback" {
  name                  = "rg-${var.name_prefix}-back-${var.name_suffix}-${var.client}"
  location              = var.location
  tags                  = var.tags
}

resource "azurerm_service_plan" "aspback" {
  name                  = "asp-${var.name_prefix}-back-${var.name_suffix}-${var.client}"
  resource_group_name   = azurerm_resource_group.rgback.name
  location              = azurerm_resource_group.rgback.location
  os_type               = "Linux"
  sku_name              = "F1"
  tags                  = var.tags
  
}

resource "azurerm_linux_web_app" "webappback" {
  name                  = "${var.client}-back-${var.name_suffix}"
  resource_group_name   = azurerm_resource_group.rgback.name
  location              = azurerm_service_plan.aspback.location
  service_plan_id       = azurerm_service_plan.aspback.id

  site_config {
    always_on = false
    application_stack {
      python_version = "3.13"
    }
  }

  app_settings          = var.app_settings
  tags                  = var.tags
}

resource "azurerm_role_assignment" "roleassignmentbackclients" {
  scope                 = azurerm_resource_group.rgback.id
  role_definition_name  = "Contributor"
  principal_id          = var.serviceprincipalbackclients_object_id
}