variable "project_id" {}
variable "region" {}
variable "resource_prefix" {}
variable "gcs_bucket_config" {}
variable "bucket_names" {
  type = map(string)
}
variable "firestore_location_id" {}
variable "rag_index_dimensions" {}
variable "application_display_name" {}
variable "environment" {}
