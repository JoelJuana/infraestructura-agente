variable "project_id" {}
variable "environment" {}
variable "sa_account_id" {}
variable "application_display_name" {}
variable "gcs_bucket_config" {}
variable "bucket_names" {
  type = map(string)
}
