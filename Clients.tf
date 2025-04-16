
module "Client1" {
  source = "./clients/risk_analysis/Client1"
  application       = "Risk_Analysis"
  location          = var.location
  business_unit     = "Risk_Analysis"
  client            = "Client1"
}