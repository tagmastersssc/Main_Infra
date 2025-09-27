
resource "azuread_application_registration" "githubappregistrationbackclientsinvoice" {
  display_name     = "clients-appregistration-${local.name_prefix}-back-invoice-${local.name_suffix}"
  sign_in_audience = "AzureADMyOrg"
}

resource "azuread_service_principal" "serviceprincipalbackclientsinvoice" {
  client_id = azuread_application_registration.githubappregistrationbackclientsinvoice.client_id
}

resource "azuread_application_federated_identity_credential" "ficgithubbackclientsinvoice" {
  application_id = azuread_application_registration.githubappregistrationbackclientsinvoice.id
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  display_name   = "clients-github-actions-cred-${local.name_prefix}-back-invoice-${local.name_suffix}"
  subject        = "${var.clients_invoice_github_back_repo}:environment:${local.environment}"
}