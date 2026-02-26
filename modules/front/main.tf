
data "azuread_client_config" "current" {}

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

resource "azurerm_key_vault" "keyvaultfrontclients" {
  name                = "k${var.client}-${var.name_suffix}"
  location            = azurerm_resource_group.rgfront.location
  resource_group_name = azurerm_resource_group.rgfront.name
  tenant_id           = data.azuread_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = var.tags
}

resource "azurerm_key_vault_access_policy" "accesspolicyfrontclients" {
  key_vault_id = azurerm_key_vault.keyvaultfrontclients.id

  tenant_id = data.azuread_client_config.current.tenant_id
  object_id = data.azuread_client_config.current.object_id

  secret_permissions = [
    "Delete",
    "Get",
    "Set",
    "List",
    "Purge",
  ]
}

resource "azurerm_key_vault_access_policy" "accesspolicyfrontclientsgithub" {
  key_vault_id = azurerm_key_vault.keyvaultfrontclients.id

  tenant_id = data.azuread_client_config.current.tenant_id
  object_id = var.serviceprincipalfrontclients_object_id

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_secret" "secretfrontclientsVITE_LOGIN_APP_URL" {
  name         = "VITE-LOGIN-APP-URL"
  value        = "https://${var.main_login_front_default_hostname}"
  key_vault_id = azurerm_key_vault.keyvaultfrontclients.id
  depends_on = [ azurerm_key_vault_access_policy.accesspolicyfrontclientsgithub ]
}