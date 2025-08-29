
resource "azurerm_resource_group" "rgfront" {
  name     = "rg-${local.name_prefix}-front-${local.name_suffix}"
  location = local.location
  tags     = local.tags
}

resource "azurerm_service_plan" "aspfront" {
  name                = "asp-${local.name_prefix}-front-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfront.name
  location            = azurerm_resource_group.rgfront.location
  os_type             = "Linux"
  sku_name            = "F1"
  tags                = local.tags

}

resource "azurerm_linux_web_app" "webappfront" {
  name                = "webapp-${local.name_prefix}-front-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfront.name
  location            = azurerm_service_plan.aspfront.location
  service_plan_id     = azurerm_service_plan.aspfront.id

  site_config {
    always_on = false
    application_stack {
      node_version = "22-lts"
    }
  }
  tags = local.tags
}