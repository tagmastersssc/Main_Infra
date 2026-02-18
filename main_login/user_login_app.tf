
resource "azuread_application" "applicationuserlogin" {
  display_name = "app-${local.name_prefix}-userlogin-${local.name_suffix}"

  sign_in_audience = "AzureADMyOrg"

  single_page_application {
    redirect_uris = ["https://${azurerm_linux_web_app.webappbacklogin.default_hostname}/auth/callback"]
  }

  api {
    requested_access_token_version = 2
  }
}

resource "azuread_application_app_role" "approleclientadmin" {
  application_id       = azuread_application.applicationuserlogin.id
  role_id              = uuid()
  allowed_member_types = ["User"]
  description          = "Administrador del cliente"
  display_name         = "Client Admin"
  value                = "client_admin"
}

resource "azuread_application_app_role" "approleclientuser" {
  application_id       = azuread_application.applicationuserlogin.id
  role_id              = uuid()
  allowed_member_types = ["User"]
  description          = "Usuario del cliente"
  display_name         = "Client User"
  value                = "client_user"
}

resource "azuread_application_app_role" "approleglobaladmin" {
  application_id       = azuread_application.applicationuserlogin.id
  role_id              = uuid()
  allowed_member_types = ["User"]
  description          = "Global Admin"
  display_name         = "Global Admin"
  value                = "global_admin"
}