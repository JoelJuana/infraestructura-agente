# outputs.tf
# Exporta valores críticos para la aplicación y la gestión.

# --------------------------------------------------------------------------------------
# 1. ENDPOINTS DE ACCESO
# --------------------------------------------------------------------------------------

output "frontend_url" {
  description = "URL pública para acceder a la aplicación web de React/TS."
  value       = google_cloud_run_v2_service.react_frontend.uri
}

output "backend_url" {
  description = "URL interna y autenticada del Backend ADK."
  value       = google_cloud_run_v2_service.agent_backend.uri
}

output "rag_index_endpoint_url" {
  description = "URL del punto de acceso de Vertex AI para consultas RAG."
  value       = google_vertex_ai_index_endpoint.rag_endpoint.uri
}

# --------------------------------------------------------------------------------------
# 2. METADATOS Y ACCESO
# --------------------------------------------------------------------------------------

output "agent_service_account_email" {
  description = "Correo electrónico de la cuenta de servicio del procesador."
  value       = google_service_account.agent_sa.email
}

output "cloud_build_service_account_email" {
  description = "Correo electrónico de la SA de Cloud Build, a la que se le dio permisos de despliegue."
  value       = data.google_project_service_identity.cloud_build_sa.email
}

output "storage_bucket_names" {
  description = "Mapa de nombres de los buckets de GCS creados."
  value       = { for k, v in google_storage_bucket.rag_raw_docs : k => v.name }
}