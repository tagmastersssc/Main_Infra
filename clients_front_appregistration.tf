
resource "azuread_application_registration" "githubappregistrationfrontclients" {
  display_name     = "clients-appregistration-${local.name_prefix}-front-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalfrontclients" {
  client_id = azuread_application_registration.githubappregistrationfrontclients.client_id
}

resource "azuread_application_federated_identity_credential" "ficgithubfrontclients" {
  application_id        = azuread_application_registration.githubappregistrationfrontclients.id
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = "https://token.actions.githubusercontent.com"
  display_name          = "clients-github-actions-cred-${local.name_prefix}-front-${local.name_suffix}"
  subject               = "${var.clients_github_front_repo}:environment:${local.environment}"
}