
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rgfront" {
  name     = "rg-${local.name_prefix}-front-${local.name_suffix}"
  location = var.main_static_web_app_location
  tags     = local.tags
}

resource "azurerm_static_web_app" "static_web_app" {
  name                = "${var.client}-front-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgfront.name
  location            = azurerm_resource_group.rgfront.location
  sku_size            = var.static_web_app_sku
  sku_tier            = var.static_web_app_sku
  tags                = local.tags
  lifecycle {
    ignore_changes = [repository_branch, repository_url]
  }
}

resource "azurerm_static_web_app_custom_domain" "custom_domain" {
  static_web_app_id = azurerm_static_web_app.static_web_app.id
  domain_name       = "${local.environment}.${var.main_domain_name}"
  validation_type   = "cname-delegation"
}

resource "azurerm_key_vault" "keyvaultfrontmain" {
  name                       = "main${local.environment}-${azurerm_resource_group.rgfront.location}"
  location                   = azurerm_resource_group.rgfront.location
  resource_group_name        = azurerm_resource_group.rgfront.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = true
  tags                       = local.tags
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