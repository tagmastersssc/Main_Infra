
resource "azuread_application_registration" "githubappregistrationbacklogin" {
  display_name     = "appregistration-${local.name_prefix}-back-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalbacklogin" {
  client_id = azuread_application_registration.githubappregistrationbacklogin.client_id
}

resource "azurerm_role_assignment" "roleassignmentbacklogin" {
  scope                = azurerm_resource_group.rgbacklogin.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.serviceprincipalbacklogin.object_id
}

resource "azuread_application_federated_identity_credential" "ficgithubbacklogin" {
  application_id = azuread_application_registration.githubappregistrationbacklogin.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "github-actions-cred-${local.name_prefix}-back-${local.name_suffix}"
  subject        = "${var.github_main_back_login_repo}:environment:${local.environment}"
}