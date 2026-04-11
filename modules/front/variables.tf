variable "name_prefix" {}
variable "name_suffix" {}
variable "location" {}
variable "environment" {}
variable "client" {}
variable "sku" {}
variable "tags" { type = map(string) }
variable "serviceprincipalfrontclients_object_id" {}
variable "main_login_front_default_hostname" {}
variable "backend_api_url" {}
variable "runtime_config_url" {}
variable "tenant_id" {}
