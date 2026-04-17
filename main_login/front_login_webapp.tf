
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rgfrontlogin" {
  name     = "rg-${local.name_prefix}-front-${local.name_suffix}"
  location = var.static_web_app_location
  tags     = local.tags
}

resource "azurerm_static_web_app" "static_web_app" {
  name                = "${var.application}-front-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfrontlogin.name
  location            = azurerm_resource_group.rgfrontlogin.location
  sku_size            = var.static_web_app_sku
  sku_tier            = var.static_web_app_sku
  tags                = local.tags
  lifecycle {
    ignore_changes = [repository_branch, repository_url]
  }
}

resource "azurerm_static_web_app_custom_domain" "custom_domain" {
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name       = "${var.application}.${local.environment}.${var.main_domain_name}"
  validation_type   = "cname-delegation"
}

resource "azurerm_key_vault" "keyvaultfrontlogin" {
  name                       = "log${local.environment}-${azurerm_resource_group.rgfrontlogin.location}"
  location                   = azurerm_resource_group.rgfrontlogin.location
  resource_group_name        = azurerm_resource_group.rgfrontlogin.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  tags                       = local.tags
}

resource "azurerm_role_assignment" "roleassignemntkeyvaultfrontlogin" {
  scope                = azurerm_key_vault.keyvaultfrontlogin.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_key_vault.keyvaultfrontlogin]
}

resource "azurerm_role_assignment" "roleassignemntkeyvaultfrontlogin_sp" {
  scope                = azurerm_key_vault.keyvaultfrontlogin.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_service_principal.serviceprincipalfrontlogin.object_id
  depends_on           = [azurerm_key_vault.keyvaultfrontlogin]
}

resource "azurerm_key_vault_secret" "secretfrontloginbackendurl" {
  name         = "VITE-API-URL"
  # value        = "https://back.${var.application}.${local.environment}.${var.main_domain_name}"
  value = "https://${azurerm_function_app_flex_consumption.webappbacklogin.default_hostname}"
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontlogin_sp]
}

resource "azurerm_key_vault_secret" "secretfrontloginmainurl" {
  name         = "VITE-WEBSITE-URL"
  value        = "https://${var.main_front_url}"
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontlogin_sp]
}
