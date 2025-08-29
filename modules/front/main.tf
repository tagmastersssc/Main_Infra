
resource "azurerm_resource_group" "rgfront" {
  name     = "rg-${var.name_prefix}-front-${var.name_suffix}-${var.client}"
  location = var.location
  tags = var.tags
}

resource "azurerm_service_plan" "aspfront" {
  name                  = "asp-${var.name_prefix}-front-${var.name_suffix}-${var.client}"
  resource_group_name   = azurerm_resource_group.rgfront.name
  location              = azurerm_resource_group.rgfront.location
  os_type               = "Linux"
  sku_name              = "F1"
  tags                  = var.tags
  
}

resource "azurerm_linux_web_app" "webappfront" {
  name                  = "${var.client}-front-${var.name_suffix}"
  resource_group_name   = azurerm_resource_group.rgfront.name
  location              = azurerm_service_plan.aspfront.location
  service_plan_id       = azurerm_service_plan.aspfront.id

  site_config {
    always_on = false
    application_stack {
      node_version = "22-lts"
    }
  }
  
  app_settings          = var.app_settings
  tags                  = var.tags
}

# resource "azurerm_app_service_custom_hostname_binding" "swebappcustomdomain" {
#   hostname            = "${var.client}.${var.environment}.${var.custom_domain_front}"
#   app_service_name    = azurerm_linux_web_app.webappfront.name
#   resource_group_name = azurerm_resource_group.rgfront.name
# }

resource "azurerm_role_assignment" "roleassignmentfrontclients" {
  scope                = azurerm_resource_group.rgfront.id
  role_definition_name = "Contributor"
  principal_id         = var.serviceprincipalfrontclients_object_id
}