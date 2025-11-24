locals {
  agent_member    = "serviceAccount:${google_service_account.agent_sa.email}"
  essential_apis = toset([
    "run.googleapis.com", "cloudbuild.googleapis.com", "storage.googleapis.com",
    "firestore.googleapis.com", "aiplatform.googleapis.com", "serviceusage.googleapis.com",
    "secretmanager.googleapis.com", "pubsub.googleapis.com", "cloudtasks.googleapis.com",
    "apigateway.googleapis.com",
    "drive.googleapis.com", "sheets.googleapis.com", "gmail.googleapis.com",
    "artifactregistry.googleapis.com",
  ])
}

data "google_project_service_identity" "cloud_build_sa" {
  service  = "cloudbuild.googleapis.com"
}

resource "google_project_service" "apis" {
  for_each = local.essential_apis
  project  = var.project_id
  service  = each.key
  disable_on_destroy = false
}

resource "google_service_account" "agent_sa" {
  account_id   = var.sa_account_id
  display_name = "${var.application_display_name} (${upper(var.environment)}) Processor SA"
  project      = var.project_id
}

resource "google_project_iam_member" "agent_roles" {
  for_each = toset([
    "roles/aiplatform.user",        
    "roles/datastore.user",         
    "roles/secretmanager.secretAccessor", 
    "roles/run.invoker",            
    "roles/cloudtasks.enqueuer",    
    "roles/pubsub.publisher",       
  ])
  project = var.project_id
  role    = each.key
  member  = local.agent_member
}

resource "google_storage_bucket_iam_member" "agent_storage_access" {
  for_each = var.gcs_bucket_config
  bucket   = var.bucket_names[each.key]
  role     = each.value.role_for_agent
  member   = local.agent_member
}
