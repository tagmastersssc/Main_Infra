
output "azurerm_ai_services_endpoint" {
  value = azurerm_ai_services.ai_services.endpoint
}

output "azurerm_ai_services_primary_access_key" {
  value = azurerm_ai_services.ai_services.primary_access_key
}

output "azurerm_cognitive_deployment_model_name" {
  value = azurerm_cognitive_deployment.cognitive_deployment.name
}