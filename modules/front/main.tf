
resource "azurerm_resource_group" "rgfront" {
  name     = "rg-${var.name_prefix}-front-${var.name_suffix}-${var.client}"
  location = var.location
  tags = var.tags
}

resource "azurerm_static_web_app" "staticappfront" {
  name                = "${var.client}-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfront.name
  location            = "eastus2"
  lifecycle {
    ignore_changes = [ 
      repository_branch,
      repository_url,
      repository_token
     ]
  }
  tags = var.tags
}

resource "azurerm_static_web_app_custom_domain" "staticappcustomdomain" {
  static_web_app_id = azurerm_static_web_app.staticappfront.id
  domain_name       = "${var.client}.${var.environment}.${var.custom_domain_front}"
  validation_type   = "cname-delegation"
}

resource "azurerm_role_assignment" "roleassignmentfrontclients" {
  scope                = azurerm_resource_group.rgfront.id
  role_definition_name = "Contributor"
  principal_id         = var.serviceprincipalfrontclients_object_id
}