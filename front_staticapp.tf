
resource "azurerm_resource_group" "rgfront" {
  name     = "rg-${local.name_prefix}-front-${local.name_suffix}"
  location = local.location
  tags     = local.tags
}

resource "azurerm_static_web_app" "staticappfront" {
  name                = "staticapp-${local.name_prefix}-front-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfront.name
  location            = "eastus2"
  lifecycle {
    ignore_changes = [
      repository_branch,
      repository_url,
      repository_token
    ]
  }
  tags = local.tags
}

resource "azurerm_static_web_app_custom_domain" "staticappcustomdomain" {
  static_web_app_id = azurerm_static_web_app.staticappfront.id
  domain_name       = "${local.environment}.${var.custom_domain_front}"
  validation_type   = "cname-delegation"
}