
resource "azuread_application" "applicationuserlogin" {
  display_name = "app-${local.name_prefix}-userlogin-${local.name_suffix}"

  sign_in_audience = "AzureADandPersonalMicrosoftAccount"

  api {
    requested_access_token_version = 2
  }
  lifecycle {
    ignore_changes = [
      app_role,
      web,
    ]
  }
}

resource "azuread_application_redirect_uris" "applicationuserloginredirecturis" {
  application_id = azuread_application.applicationuserlogin.id
  type           = "Web"
  # redirect_uris  = ["https://back.${var.application}.${local.environment}.${var.main_domain_name}/auth/sso/callback", "http://localhost:8000/auth/sso/callback"]
  redirect_uris  = ["https://${azurerm_function_app_flex_consumption.webappbacklogin.default_hostname}/auth/sso/callback", "http://localhost:8000/auth/sso/callback"]

}

resource "azuread_application_password" "applicationuserloginpassword" {
  application_id = azuread_application.applicationuserlogin.id
}

resource "azuread_application_app_role" "approleclientadmin" {
  application_id       = azuread_application.applicationuserlogin.id
  role_id              = uuid()
  allowed_member_types = ["User"]
  description          = "Administrador del cliente"
  display_name         = "Client Admin"
  value                = "client_admin"
  lifecycle {
    ignore_changes = [role_id]
  }
}

resource "azuread_application_app_role" "approleclientuser" {
  application_id       = azuread_application.applicationuserlogin.id
  role_id              = uuid()
  allowed_member_types = ["User"]
  description          = "Usuario del cliente"
  display_name         = "Client User"
  value                = "client_user"
  lifecycle {
    ignore_changes = [role_id]
  }
}

resource "azuread_application_app_role" "approleglobaladmin" {
  application_id       = azuread_application.applicationuserlogin.id
  role_id              = uuid()
  allowed_member_types = ["User"]
  description          = "Global Admin"
  display_name         = "Global Admin"
  value                = "global_admin"
  lifecycle {
    ignore_changes = [role_id]
  }
}