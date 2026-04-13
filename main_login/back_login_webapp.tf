
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

resource "azurerm_service_plan" "aspbacklogin" {
  name                = "asp-${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgbacklogin.name
  location            = azurerm_resource_group.rgbacklogin.location
  os_type             = "Linux"
  sku_name            = local.login_back_sku_name
  tags                = local.tags

}

resource "azurerm_linux_web_app" "webappbacklogin" {
  name                = "webapp-${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgbacklogin.name
  location            = azurerm_service_plan.aspbacklogin.location
  service_plan_id     = azurerm_service_plan.aspbacklogin.id
  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = "1"

    ENABLE_PASSWORD_AUTH          = "false",
    OIDC_TENANT_ID                = data.azuread_client_config.current.tenant_id
    OIDC_DISCOVERY_URL            = "https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration"
    OIDC_CLIENT_ID                = azuread_application.applicationuserlogin.client_id
    OIDC_CLIENT_SECRET            = azuread_application_password.applicationuserloginpassword.value
    OIDC_PUBLIC_CLIENT            = "false"
    OIDC_SCOPE                    = "openid profile email"
    SSO_REDIRECT_URI              = "https://${local.login_back_hostname}/auth/sso/callback"
    OIDC_PROVIDER_HINT_PARAM      = "idp"
    APP_TOKEN_SECRET              = random_password.mainloginapptokensecret.result
    APP_TOKEN_TTL_SECONDS         = "28800"
    SESSION_COOKIE_NAME           = "bilai_portal_session"
    SESSION_COOKIE_DOMAIN         = ""
    SESSION_COOKIE_PATH           = "/"
    SESSION_COOKIE_SAMESITE       = "none"
    SESSION_COOKIE_SECURE         = "true"
    LOGIN_FRONT_URL               = "https://${local.login_front_hostname}"
    CLIENTS_APP_URL               = ""
    CLIENTS_BACKEND_URL           = ""
    DEFAULT_TENANT_ID             = var.default_customer_tenant_id
    TENANT_EXCHANGE_SECRET        = ""
    TENANT_LOGIN_CODE_TTL_SECONDS = "300"
    TENANT_CONFIG_JSON            = var.tenant_registry_json
    REQUIRE_ALLOWLIST             = "true"
    ALLOWED_EMAILS                = ""
    SSO_STATE_TTL_SECONDS         = "900"
    ALLOWED_ORIGINS               = "https://${local.login_front_hostname},https://${var.main_front_url}"

  }
  site_config {
    app_command_line = "gunicorn -w 2 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000 main:app"
    cors {
      allowed_origins     = ["https://${local.login_front_hostname}", "https://${var.main_front_url}"]
      support_credentials = true
    }
    always_on = false
    application_stack {
      python_version = "3.13"
    }
  }
  tags = local.tags
}

resource "azurerm_app_service_custom_hostname_binding" "webappbacklogin_custom_hostname" {
  count               = trimspace(var.back_custom_domain) != "" ? 1 : 0
  resource_group_name = azurerm_resource_group.rgbacklogin.name
  app_service_name    = azurerm_linux_web_app.webappbacklogin.name
  hostname            = trimspace(var.back_custom_domain)
}

resource "azurerm_app_service_managed_certificate" "webappbacklogin_managed_certificate" {
  count                      = trimspace(var.back_custom_domain) != "" ? 1 : 0
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.webappbacklogin_custom_hostname[0].id
}

resource "azurerm_app_service_certificate_binding" "webappbacklogin_certificate_binding" {
  count               = trimspace(var.back_custom_domain) != "" ? 1 : 0
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.webappbacklogin_custom_hostname[0].id
  certificate_id      = azurerm_app_service_managed_certificate.webappbacklogin_managed_certificate[0].id
  ssl_state           = "SniEnabled"
}
