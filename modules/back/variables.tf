variable "name_prefix" {}
variable "name_suffix" {}
variable "location" {}
variable "environment" {}
variable "client" {}
variable "tags" { type = map(string) }
variable "serviceprincipalbackclients_object_id" {}
variable "app_settings" { type = map(string) }
variable "cors_allowed_origins" { type = list(string) }
variable "custom_hostname" {}
