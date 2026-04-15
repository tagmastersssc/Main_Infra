
data "azuread_client_config" "current" {}

resource "random_password" "mainloginapptokensecret" {
  length  = 64
  special = false
}

resource "azurerm_resource_group" "rgbacklogin" {
  name     = "rg-${local.name_prefix}-back-${local.name_suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "backstorageaccount" {
  name                     = "log${lower(var.client)}${local.environment}"
  resource_group_name      = azurerm_resource_group.rgbacklogin.name
  location                 = azurerm_resource_group.rgbacklogin.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "${lower(var.client)}${local.environment}-flexcontainer"
  storage_account_id    = azurerm_storage_account.backstorageaccount.id
  container_access_type = "private"
}

resource "azurerm_service_plan" "aspbacklogin" {
  name                = "asp-${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgbacklogin.name
  location            = azurerm_resource_group.rgbacklogin.location
  os_type             = "Linux"
  sku_name            = "FC1"
  tags                = local.tags

}

resource "azurerm_function_app_flex_consumption" "webappbacklogin" {
  name                = "${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgbacklogin.name
  location            = azurerm_service_plan.aspbacklogin.location
  service_plan_id     = azurerm_service_plan.aspbacklogin.id
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.backstorageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.backstorageaccount.primary_access_key
  runtime_version             = "3.13"
  runtime_name                = "python"
  app_settings = {
    ENABLE_PASSWORD_AUTH          = "false",
    OIDC_TENANT_ID                = data.azuread_client_config.current.tenant_id
    OIDC_DISCOVERY_URL            = "https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration"
    OIDC_CLIENT_ID                = azuread_application.applicationuserlogin.client_id
    OIDC_CLIENT_SECRET            = azuread_application_password.applicationuserloginpassword.value
    OIDC_PUBLIC_CLIENT            = "false"
    OIDC_SCOPE                    = "openid profile email"
    SSO_REDIRECT_URI              = "https://back.${var.application}.${local.environment}.${var.main_domain_name}/auth/sso/callback"
    OIDC_PROVIDER_HINT_PARAM      = "idp"
    APP_TOKEN_SECRET              = random_password.mainloginapptokensecret.result
    APP_TOKEN_TTL_SECONDS         = "28800"
    SESSION_COOKIE_NAME           = "bilai_portal_session"
    SESSION_COOKIE_DOMAIN         = ""
    SESSION_COOKIE_PATH           = "/"
    SESSION_COOKIE_SAMESITE       = "none"
    SESSION_COOKIE_SECURE         = "true"
    LOGIN_FRONT_URL               = "https://${var.application}.${local.environment}.${var.main_domain_name}"
    CLIENTS_APP_URL               = ""
    CLIENTS_BACKEND_URL           = ""
    DEFAULT_TENANT_ID             = var.default_customer_tenant_id
    TENANT_EXCHANGE_SECRET        = ""
    TENANT_LOGIN_CODE_TTL_SECONDS = "300"
    TENANT_CONFIG_JSON            = var.tenant_registry_json
    REQUIRE_ALLOWLIST             = "true"
    ALLOWED_EMAILS                = ""
    SSO_STATE_TTL_SECONDS         = "900"
    ALLOWED_ORIGINS               = "https://${var.application}.${local.environment}.${var.main_domain_name},https://${var.main_front_url}"

  }
  site_config {
    scm_ip_restriction {
      priority    = "100"
      action      = "Allow"
      service_tag = "AzureCloud"
      name        = "AzureGitHub"
    }
    cors {
      allowed_origins     = ["https://${var.application}.${local.environment}.${var.main_domain_name}", "https://${var.main_front_url}"]
      support_credentials = true
    }
  }
  tags = local.tags
}

resource "azurerm_app_service_custom_hostname_binding" "custom_hostname" {
  hostname            = "back.${var.application}.${local.environment}.${var.main_domain_name}"
  app_service_name    = azurerm_function_app_flex_consumption.webappbacklogin.name
  resource_group_name = azurerm_resource_group.rgbacklogin.name
}