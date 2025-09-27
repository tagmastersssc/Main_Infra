
resource "azuread_application_registration" "githubappregistrationfrontclientsinvoice" {
  display_name     = "clients-appregistration-${local.name_prefix}-front-invoice-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalfrontclientsinvoice" {
  client_id = azuread_application_registration.githubappregistrationfrontclientsinvoice.client_id
}

resource "azuread_application_federated_identity_credential" "ficgithubfrontclientsinvoice" {
  application_id = azuread_application_registration.githubappregistrationfrontclientsinvoice.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "clients-github-actions-cred-${local.name_prefix}-front-invoice-${local.name_suffix}"
  subject        = "${var.clients_invoice_github_front_repo}:environment:${local.environment}"
}