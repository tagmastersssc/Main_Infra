
resource "azurerm_resource_group" "rgfront" {
  name     = "rg-${var.name_prefix}-front-${var.name_suffix}-${var.client}"
  location = var.location
  tags = var.tags
}

resource "azurerm_static_web_app" "static_web_app" {
  name                = "${var.client}-front-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfront.name
  location            = azurerm_resource_group.rgfront.location
  sku_size            = var.sku
  sku_tier            = var.sku 
  app_settings        = var.app_settings
  tags                = var.tags
  lifecycle {
    ignore_changes = [ repository_branch, repository_url ]
  }
}

resource "azurerm_role_assignment" "roleassignmentfrontclients" {
  scope                = azurerm_resource_group.rgfront.id
  role_definition_name = "Contributor"
  principal_id         = var.serviceprincipalfrontclients_object_id
}