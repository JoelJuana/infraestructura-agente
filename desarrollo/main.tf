locals {
  resource_prefix = "${var.application_name}-${var.environment}"
  # Pre-calculate bucket names to avoid cyclic dependency
  bucket_names = {
    for k, v in var.gcs_bucket_config : k => "${local.resource_prefix}-bkt-${v.name_suffix}-${var.project_id}"
  }
}

module "iam_roles" {
  source = "./modules/iam-roles"

  project_id               = var.project_id
  environment              = var.environment
  sa_account_id            = var.sa_account_id
  application_display_name = var.application_display_name
  gcs_bucket_config        = var.gcs_bucket_config
  bucket_names             = local.bucket_names
}

module "data_layer" {
  source = "./modules/data-layer"

  project_id               = var.project_id
  region                   = var.region
  resource_prefix          = local.resource_prefix
  gcs_bucket_config        = var.gcs_bucket_config
  bucket_names             = local.bucket_names
  firestore_location_id    = var.firestore_location_id
  rag_index_dimensions     = var.rag_index_dimensions
  application_display_name = var.application_display_name
  environment              = var.environment
  
  depends_on = [module.iam_roles]
}

module "compute_backend" {
  source = "./modules/compute-backend"

  project_id           = var.project_id
  region               = var.region
  resource_prefix      = local.resource_prefix
  agent_backend_config = var.agent_backend_config
  agent_sa_email       = module.iam_roles.agent_sa_email
  
  depends_on = [module.iam_roles]
}