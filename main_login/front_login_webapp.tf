
resource "azurerm_resource_group" "rgfrontlogin" {
  name     = "rg-${local.name_prefix}-front-${local.name_suffix}"
  location = local.location
  tags     = local.tags
}

resource "azurerm_service_plan" "aspfrontlogin" {
  name                = "asp-${local.name_prefix}-front-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfrontlogin.name
  location            = azurerm_resource_group.rgfrontlogin.location
  os_type             = "Linux"
  sku_name            = "F1"
  tags                = local.tags

}

resource "azurerm_linux_web_app" "webappfrontlogin" {
  name                = "webapp-${local.name_prefix}-front-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfrontlogin.name
  location            = azurerm_service_plan.aspfrontlogin.location
  service_plan_id     = azurerm_service_plan.aspfrontlogin.id

  site_config {
    always_on = false
    application_stack {
      node_version = "22-lts"
    }
    app_command_line = "pm2 serve /home/site/wwwroot --no-daemon"
  }
  tags = local.tags
}