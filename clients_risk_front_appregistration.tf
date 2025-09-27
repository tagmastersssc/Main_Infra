
resource "azuread_application_registration" "githubappregistrationfrontclientsrisk" {
  display_name     = "clients-appregistration-${local.name_prefix}-front-risk-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalfrontclientsrisk" {
  client_id = azuread_application_registration.githubappregistrationfrontclientsrisk.client_id
}

resource "azuread_application_federated_identity_credential" "ficgithubfrontclientsrisk" {
  application_id = azuread_application_registration.githubappregistrationfrontclientsrisk.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "clients-github-actions-cred-${local.name_prefix}-front-risk-${local.name_suffix}"
  subject        = "${var.clients_risk_github_front_repo}:environment:${local.environment}"
}