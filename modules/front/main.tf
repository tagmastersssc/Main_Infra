
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rgfront" {
  name     = "rg-${var.name_prefix}-front-${var.name_suffix}-${var.client}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_static_web_app" "static_web_app" {
  name                = "${var.client}-front-${var.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfront.name
  location            = azurerm_resource_group.rgfront.location
  sku_size            = var.sku
  sku_tier            = var.sku
  tags                = var.tags
  lifecycle {
    ignore_changes = [repository_branch, repository_url]
  }
}

resource "azurerm_static_web_app_custom_domain" "custom_domain" {
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name       = "${var.client}.${var.environment}.${var.main_domain_name}"
  validation_type   = "cname-delegation"
}

resource "azurerm_role_assignment" "roleassignmentfrontclients" {
  scope                = azurerm_resource_group.rgfront.id
  role_definition_name = "Contributor"
  principal_id         = var.serviceprincipalfrontclients_object_id
}

resource "azurerm_key_vault" "keyvaultfrontclients" {
  name                       = "${var.client}${var.name_suffix}"
  location                   = azurerm_resource_group.rgfront.location
  resource_group_name        = azurerm_resource_group.rgfront.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  tags                       = var.tags
}

resource "azurerm_role_assignment" "roleassignemntkeyvaultfrontclients" {
  scope                = azurerm_key_vault.keyvaultfrontclients.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_key_vault.keyvaultfrontclients]
}

resource "azurerm_role_assignment" "roleassignemntkeyvaultfrontclientssp" {
  scope                = azurerm_key_vault.keyvaultfrontclients.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.serviceprincipalfrontclients_object_id
  depends_on           = [azurerm_key_vault.keyvaultfrontclients]
}

resource "azurerm_key_vault_secret" "secretfrontclientsVITE_LOGIN_APP_URL" {
  name         = "VITE-LOGIN-APP-URL"
  value        = "https://${var.main_login_front_default_hostname}"
  key_vault_id = azurerm_key_vault.keyvaultfrontclients.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontclientssp]
}

resource "azurerm_key_vault_secret" "secretfrontclientsVITE_API_URL" {
  name         = "VITE-API-URL"
  value        = var.backend_api_url
  key_vault_id = azurerm_key_vault.keyvaultfrontclients.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontclientssp]
}

resource "azurerm_key_vault_secret" "secretfrontclientsVITE_RUNTIME_CONFIG_URL" {
  name         = "VITE-RUNTIME-CONFIG-URL"
  value        = var.runtime_config_url
  key_vault_id = azurerm_key_vault.keyvaultfrontclients.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontclientssp]
}

resource "azurerm_key_vault_secret" "secretfrontclientsVITE_APP_TENANT_ID" {
  name         = "VITE-APP-TENANT-ID"
  value        = var.tenant_id
  key_vault_id = azurerm_key_vault.keyvaultfrontclients.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontclientssp]
}
