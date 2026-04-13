
data "azurerm_client_config" "current" {}

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
  sku_name            = local.login_front_sku_name
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

resource "azurerm_app_service_custom_hostname_binding" "webappfrontlogin_custom_hostname" {
  count               = trimspace(var.front_custom_domain) != "" ? 1 : 0
  resource_group_name = azurerm_resource_group.rgfrontlogin.name
  app_service_name    = azurerm_linux_web_app.webappfrontlogin.name
  hostname            = trimspace(var.front_custom_domain)
}

resource "azurerm_app_service_managed_certificate" "webappfrontlogin_managed_certificate" {
  count                      = trimspace(var.front_custom_domain) != "" ? 1 : 0
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.webappfrontlogin_custom_hostname[0].id
}

resource "azurerm_app_service_certificate_binding" "webappfrontlogin_certificate_binding" {
  count               = trimspace(var.front_custom_domain) != "" ? 1 : 0
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.webappfrontlogin_custom_hostname[0].id
  certificate_id      = azurerm_app_service_managed_certificate.webappfrontlogin_managed_certificate[0].id
  ssl_state           = "SniEnabled"
}

resource "azurerm_key_vault" "keyvaultfrontlogin" {
  name                       = "log${local.name_suffix}"
  location                   = azurerm_resource_group.rgfrontlogin.location
  resource_group_name        = azurerm_resource_group.rgfrontlogin.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  tags                       = local.tags
  # access_policy {
  #   tenant_id = data.azuread_client_config.current.tenant_id
  #   object_id = data.azuread_client_config.current.object_id

  #   secret_permissions = [
  #     "Delete",
  #     "Get",
  #     "Set",
  #     "List",
  #     "Purge",
  #   ]
  # }
  # access_policy {
  #   tenant_id = data.azuread_client_config.current.tenant_id
  #   object_id = azuread_service_principal.serviceprincipalfrontlogin.object_id

  #   secret_permissions = [
  #     "Delete",
  #     "Get",
  #     "Set",
  #     "List",
  #     "Purge",
  #   ]
  # }
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
  value        = "https://${local.login_back_hostname}"
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontlogin_sp]
}

resource "azurerm_key_vault_secret" "secretfrontloginmainurl" {
  name         = "VITE-WEBSITE-URL"
  value        = "https://${var.main_front_url}"
  key_vault_id = azurerm_key_vault.keyvaultfrontlogin.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontlogin_sp]
}
