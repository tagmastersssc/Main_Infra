
resource "azuread_application_registration" "githubappregistrationbackclientsrisk" {
  display_name     = "clients-appregistration-${local.name_prefix}-back-risk-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalbackclientsrisk" {
  client_id = azuread_application_registration.githubappregistrationbackclientsrisk.client_id
}

resource "azuread_application_federated_identity_credential" "ficgithubbackclientsrisk" {
  application_id = azuread_application_registration.githubappregistrationbackclientsrisk.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "clients-github-actions-cred-${local.name_prefix}-back-risk-${local.name_suffix}"
  subject        = "${var.clients_risk_github_back_repo}:environment:${local.environment}"
}