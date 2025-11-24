resource "google_cloud_run_v2_service" "agent_backend" {
    name       = "${var.resource_prefix}-svc-${var.agent_backend_config.name}" 
    location   = var.region
    project    = var.project_id

    template {
        timeout_seconds       = var.agent_backend_config.timeout_seconds
        
        scaling {
            min_instance_count = var.agent_backend_config.min_instances
            max_instance_count = var.agent_backend_config.concurrency # Using concurrency as max instances proxy or just 100 default? Let's use 10 for dev as per tfvars
        }

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
    ingress = "INGRESS_TRAFFIC_ALL" # PUBLIC ACCESS FOR PROTOTYPE
}

resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_v2_service.agent_backend.name
  location = google_cloud_run_v2_service.agent_backend.location
  project  = google_cloud_run_v2_service.agent_backend.project
  role     = "roles/run.invoker"
  member   = "allUsers"
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
