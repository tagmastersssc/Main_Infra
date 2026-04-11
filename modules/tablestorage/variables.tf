variable "name_prefix" {}
variable "name_suffix" {}
variable "location" {}
variable "environment" {}
variable "client" {}
variable "tags" { type = map(string) }
variable "serviceprincipalbackclients_object_id" {}