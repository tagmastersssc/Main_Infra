
resource "azurerm_resource_group" "rgback" {
  name     = "rg-${local.name_prefix}-back-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_service_plan" "aspback" {
  name                = "asp-${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgback.name
  location            = azurerm_resource_group.rgback.location
  os_type             = "Linux"
  sku_name            = "F1"
  tags                = local.tags

}

resource "azurerm_linux_web_app" "webappback" {
  name                = "webapp-${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgback.name
  location            = azurerm_service_plan.aspback.location
  service_plan_id     = azurerm_service_plan.aspback.id

  site_config {
    always_on = false
    application_stack {
      python_version = "3.13"
    }
  }
  tags = local.tags
}