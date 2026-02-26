
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

resource "azurerm_key_vault" "keyvaultfrontlogin" {
  name                = "kv-login-${local.name_suffix}"
  location            = azurerm_resource_group.rgfrontlogin.location
  resource_group_name = azurerm_resource_group.rgfrontlogin.name
  tenant_id           = data.azuread_client_config.current.tenant_id
  sku_name            = "standard"
  tags                = local.tags
}

resource "azurerm_key_vault_access_policy" "accesspolicyfrontlogin" {
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id

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

resource "azurerm_key_vault_access_policy" "accesspolicyfrontlogingithub" {
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id

  tenant_id = data.azuread_client_config.current.tenant_id
  object_id = azuread_service_principal.serviceprincipalfrontlogin.object_id

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_key_vault_secret" "secretfrontloginbackendurl" {
  name         = "VITE-API-URL"
  value        = "https://${azurerm_linux_web_app.webappbacklogin.default_hostname}"
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id
  depends_on = [ azurerm_key_vault_access_policy.accesspolicyfrontlogin ]
}

resource "azurerm_key_vault_secret" "secretfrontloginmainurl" {
  name         = "VITE-WEBSITE-URL"
  value        = "https://${var.main_front_url}"
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id
  depends_on = [ azurerm_key_vault_access_policy.accesspolicyfrontlogin ]
}

