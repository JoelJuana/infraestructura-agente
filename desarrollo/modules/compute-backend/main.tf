resource "google_cloud_run_v2_service" "agent_backend" {
    name       = "${var.resource_prefix}-svc-${var.agent_backend_config.name}" 
    location   = var.region
    project    = var.project_id

    template {
        timeout_seconds       = var.agent_backend_config.timeout_seconds
        container_concurrency = var.agent_backend_config.concurrency

        containers {
            image = var.agent_backend_config.image
            resources {
                memory = var.agent_backend_config.memory
                cpu    = var.agent_backend_config.cpu
            }
            env {
                name  = "GCP_PROJECT_ID"
                value = var.project_id
            }
        }
        service_account = var.agent_sa_email
    }
    ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER" 
}

resource "google_cloud_run_v2_service" "react_frontend" {
    name       = "${var.resource_prefix}-svc-frontend"
    location   = var.region
    project    = var.project_id

    template {
        containers {
            image = "us-docker.pkg.dev/cloudrun/container/hello" 
            env {
                name  = "REACT_APP_API_URL"
                value = google_cloud_run_v2_service.agent_backend.uri
            }
        }
    }

    ingress = "INGRESS_TRAFFIC_ALL"
}
