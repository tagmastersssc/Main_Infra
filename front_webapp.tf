
data "azurerm_client_config" "current" {}

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
    app_command_line = "pm2 serve /home/site/wwwroot --no-daemon"
  }
  tags = local.tags
}

resource "azurerm_key_vault" "keyvaultfrontmain" {
  name                       = "main${local.name_suffix}"
  location                   = azurerm_resource_group.rgfront.location
  resource_group_name        = azurerm_resource_group.rgfront.name
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
  #   object_id = azuread_service_principal.serviceprincipalfront.object_id

  #   secret_permissions = [
  #     "Delete",
  #     "Get",
  #     "Set",
  #     "List",
  #     "Purge",
  #   ]
  # }
}

resource "azurerm_role_assignment" "roleassignemntkeyvaultfrontmain" {
  scope                = azurerm_key_vault.keyvaultfrontmain.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_key_vault.keyvaultfrontmain]
}

resource "azurerm_role_assignment" "roleassignemntkeyvaultfrontmain_sp" {
  scope                = azurerm_key_vault.keyvaultfrontmain.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_service_principal.serviceprincipalfront.object_id
  depends_on           = [azurerm_key_vault.keyvaultfrontmain]
}

resource "azurerm_key_vault_secret" "secretfrontmainVITE_LOGIN_URL" {
  name         = "VITE-LOGIN-URL"
  value        = "https://${module.Main_Login.front_azurerm_linux_web_app_hostname}"
  key_vault_id = azurerm_key_vault.keyvaultfrontmain.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontmain_sp]
}

resource "azurerm_key_vault_secret" "secretfrontmainVITE_WHATSAPP_URL" {
  name         = "VITE-WHATSAPP-URL"
  value        = "https://wa.me/573001112233?text=Hola BilAI%2C quiero conocer la plataforma"
  key_vault_id = azurerm_key_vault.keyvaultfrontmain.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontmain_sp]
}

resource "azurerm_key_vault_secret" "secretfrontmainVITE_CONTACT_EMAIL" {
  name         = "VITE-CONTACT-EMAIL"
  value        = "ventas@bilai.com"
  key_vault_id = azurerm_key_vault.keyvaultfrontmain.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontmain_sp]
}

resource "azurerm_key_vault_secret" "secretfrontmainVITE_GA_MEASUREMENT_ID" {
  name         = "VITE-GA-MEASUREMENT-ID"
  value        = "G-XXXXXXXXXX"
  key_vault_id = azurerm_key_vault.keyvaultfrontmain.id
  depends_on   = [azurerm_role_assignment.roleassignemntkeyvaultfrontmain_sp]
}