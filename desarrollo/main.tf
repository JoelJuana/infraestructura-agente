# main.tf
# Define los servicios de ejecución de la aplicación (Cloud Run).

# --------------------------------------------------------------------------------------
# 1. BACKEND DEL AGENTE (CLOUD RUN V2 - PRIVADO)
# --------------------------------------------------------------------------------------

resource "google_cloud_run_v2_service" "agent_backend" {
    # Nomenclatura profesional: [app]-[env]-svc-backend
    name       = "${local.resource_prefix}-svc-${var.agent_backend_config.name}" 
    location   = var.region

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
        # Conexión con la Service Account creada en iam.tf
        service_account = google_service_account.agent_sa.email
    }
    # No permitimos acceso no autenticado por defecto
    ingress = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER" 
    depends_on = [google_project_service.apis]
}

# --------------------------------------------------------------------------------------
# 2. FRONTEND (CLOUD RUN V2 - PÚBLICO)
# --------------------------------------------------------------------------------------

resource "google_cloud_run_v2_service" "react_frontend" {
    # Nomenclatura profesional: [app]-[env]-svc-frontend
    name       = "${local.resource_prefix}-svc-frontend"
    location   = var.region

    template {
        containers {
            image = "us-docker.pkg.dev/cloudrun/container/hello" 
            env {
                # Inyección de la URL del Backend para que el Frontend sepa dónde llamar
                name  = "REACT_APP_API_URL"
                value = google_cloud_run_v2_service.agent_backend.uri
            }
        }
    }

    # CRÍTICO: Debe ser público para el acceso del usuario final
    ingress = "INGRESS_TRAFFIC_ALL"
    depends_on = [google_project_service.apis]
}