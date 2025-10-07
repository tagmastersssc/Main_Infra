output "table_storage_connection_string" {
  value = azurerm_storage_account.storagetablestorageaccount.primary_connection_string
}