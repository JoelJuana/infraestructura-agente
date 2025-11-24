# prod.tfvars
# VALORES DE CONFIGURACIÓN PARA EL ENTORNO DE PRODUCCIÓN (PROD)

project_id = "adk-proyecto-produccion-999" # UPDATE THIS
region     = "us-central1" 
application_name = "adk" 
application_display_name = "Agente de Conocimiento ADK"
environment = "prod"

sa_account_id = "adk-prod-processor-sa" 
firestore_location_id = "nam5" 
rag_index_dimensions = 768

agent_backend_config = {
    name = "backend"
    image = "gcr.io/adk-proyecto-produccion-999/adk-agent:prod"
    cpu = 2                 
    memory = "4Gi"          
    timeout_seconds = 600   
    concurrency = 80        
}

gcs_bucket_config = {
    "input_a" : { 
        name_suffix = "input-a", 
        role_for_agent = "roles/storage.objectAdmin", 
        force_destroy = false # CRÍTICO: PROTECCIÓN DE DATOS
    },
    "output" : { 
        name_suffix = "output",  
        role_for_agent = "roles/storage.objectCreator", 
        force_destroy = false 
    },
}
