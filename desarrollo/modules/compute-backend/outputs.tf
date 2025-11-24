output "backend_uri" {
  value = google_cloud_run_v2_service.agent_backend.uri
}
output "frontend_uri" {
  value = google_cloud_run_v2_service.react_frontend.uri
}
