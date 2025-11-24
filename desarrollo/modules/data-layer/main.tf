resource "google_storage_bucket" "rag_raw_docs" {
    for_each = var.gcs_bucket_config
    name     = var.bucket_names[each.key]
    location = var.region
    force_destroy = each.value.force_destroy
    uniform_bucket_level_access = true
}

resource "google_firestore_database" "firestore_db" {
    project     = var.project_id
    name        = "(default)"
    location_id = var.firestore_location_id 
    type        = "FIRESTORE_NATIVE"
}

resource "google_vertex_ai_index" "rag_index" {
    project      = var.project_id
    region       = var.region
    display_name = "${var.resource_prefix}-ai-index"
    description  = "Índice de vectores para ${var.application_display_name} en ${upper(var.environment)}."
    metadata {
        contents {
            dimensions = var.rag_index_dimensions
            config {
                distance_measure_type = "DOT_PRODUCT"
            }
        }
    }
}

resource "google_vertex_ai_index_endpoint" "rag_endpoint" {
    project      = var.project_id
    region       = var.region
    display_name = "${var.resource_prefix}-ai-endpoint"
    description  = "Endpoint para consultas RAG del ${var.application_display_name}."
    depends_on = [google_vertex_ai_index.rag_index]
}

resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "${var.resource_prefix}-repo"
  description   = "Docker repository for ${var.application_display_name}"
  format        = "DOCKER"
}
