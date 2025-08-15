
resource "azuread_application_registration" "githubappregistrationbackclients" {
  display_name     = "clients-appregistration-${local.name_prefix}-back-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalbackclients" {
  client_id = azuread_application_registration.githubappregistrationbackclients.client_id
}

resource "azuread_application_federated_identity_credential" "ficgithubbackclients" {
  application_id        = azuread_application_registration.githubappregistrationbackclients.id
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  display_name          = "clients-github-actions-cred-${local.name_prefix}-back-${local.name_suffix}"
  subject               = "${var.clients_github_back_repo}:environment:${local.environment}"
}