
resource "azuread_application_registration" "githubappregistrationfront" {
  display_name     = "appregistration-${local.name_prefix}-front-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalfront" {
  client_id = azuread_application_registration.githubappregistrationfront.client_id
}

resource "azurerm_role_assignment" "roleassignmentfront" {
  scope                = azurerm_resource_group.rgfront.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.serviceprincipalfront.object_id
}

resource "azuread_application_federated_identity_credential" "ficgithubfront" {
  application_id = azuread_application_registration.githubappregistrationfront.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "github-actions-cred-${local.name_prefix}-front-${local.name_suffix}"
  subject        = "${var.github_front_repo}:environment:${local.environment}"
}