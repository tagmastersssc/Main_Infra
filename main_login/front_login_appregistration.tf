
resource "azuread_application_registration" "githubappregistrationfrontlogin" {
  display_name     = "appregistration-${local.name_prefix}-front-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalfrontlogin" {
  client_id = azuread_application_registration.githubappregistrationfrontlogin.client_id
}

resource "azurerm_role_assignment" "roleassignmentfrontlogin" {
  scope                = azurerm_resource_group.rgfrontlogin.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.serviceprincipalfrontlogin.object_id
}

resource "azuread_application_federated_identity_credential" "ficgithubfrontlogin" {
  application_id = azuread_application_registration.githubappregistrationfrontlogin.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "github-actions-cred-${local.name_prefix}-front-${local.name_suffix}"
  subject        = "${var.github_main_front_login_repo}:environment:${local.environment}"
}