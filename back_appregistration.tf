
resource "azuread_application_registration" "githubappregistrationback" {
  display_name     = "appregistration-${local.name_prefix}-back-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalback" {
  client_id = azuread_application_registration.githubappregistrationback.client_id
}

resource "azurerm_role_assignment" "roleassignmentback" {
  scope                = azurerm_resource_group.rgback.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.serviceprincipalback.object_id
}

resource "azuread_application_federated_identity_credential" "ficgithubback" {
  application_id = azuread_application_registration.githubappregistrationback.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "github-actions-cred-${local.name_prefix}-back-${local.name_suffix}"
  subject        = "${var.github_back_repo}:environment:${local.environment}"
}