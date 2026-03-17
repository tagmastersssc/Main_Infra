
data "azuread_client_config" "current" {}

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
  sku_name            = "F1"
  tags                = local.tags

}

resource "azurerm_linux_web_app" "webappbacklogin" {
  name                = "webapp-${local.name_prefix}-back-${local.name_suffix}"
  resource_group_name = azurerm_resource_group.rgbacklogin.name
  location            = azurerm_service_plan.aspbacklogin.location
  service_plan_id     = azurerm_service_plan.aspbacklogin.id
  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT  = "1"

    ENABLE_PASSWORD_AUTH            = "false",
    OIDC_TENANT_ID                  = data.azuread_client_config.current.tenant_id
    OIDC_DISCOVERY_URL              = "https://login.microsoftonline.com/common/v2.0/.well-known/openid-configuration"
    OIDC_CLIENT_ID                  = azuread_application.applicationuserlogin.client_id
    OIDC_CLIENT_SECRET              = azuread_application_password.applicationuserloginpassword.value
    OIDC_PUBLIC_CLIENT              = "false"
    OIDC_SCOPE                      = "openid profile email"
    SSO_REDIRECT_URI                = "https://webapp-${local.name_prefix}-back-${local.name_suffix}.azurewebsites.net/auth/sso/callback" #REVISAR!!!!!
    OIDC_PROVIDER_HINT_PARAM        = "idp"
    APP_TOKEN_SECRET                = "local-dev-secret-change-before-production"
    APP_TOKEN_TTL_SECONDS           = "288000" 
    LOGIN_FRONT_URL                 = "https://${azurerm_linux_web_app.webappfrontlogin.default_hostname}"
    CLIENTS_APP_URL                 = "https://${var.borrar}" #REVISAR!!!!!
    REQUIRE_ALLOWLIST               = "true"
    ALLOWED_EMAILS                  = "santiagomejia.r02@gmail.com,smejiar@unbosque.edu.co,gonzalez915@outlook.com" #REVISAR!!!!!
    SSO_STATE_TTL_SECONDS           = "900"

  }
  site_config {
    app_command_line  = "gunicorn -w 2 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000 main:app"
    cors {
      allowed_origins = ["https://${azurerm_linux_web_app.webappfrontlogin.default_hostname}","https://${var.main_front_url}","https://${var.borrar}"]
    }
    always_on = false
    application_stack {
      python_version = "3.13"
    }
  }
  tags = local.tags
}

