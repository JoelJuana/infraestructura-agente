# dev.tfvars
# VALORES DE CONFIGURACIÓN PARA EL ENTORNO DE DESARROLLO (DEV)

# --------------------------------------------------------------------------------------
# 1. METADATOS CLAVE
# --------------------------------------------------------------------------------------

project_id = "adk-proyecto-desarrollo-999" 
region     = "us-central1" 
application_name = "adk" 
application_display_name = "Agente de Conocimiento ADK"
environment = "dev" # Prefijo resultante: adk-dev

# --------------------------------------------------------------------------------------
# 2. CONFIGURACIÓN DE IDENTIDAD Y DATOS
# --------------------------------------------------------------------------------------

sa_account_id = "adk-dev-processor-sa" 
firestore_location_id = "nam5" 
rag_index_dimensions = 768

# --------------------------------------------------------------------------------------
# 3. CONFIGURACIÓN DE COMPUTE (CLOUD RUN)
# --------------------------------------------------------------------------------------

agent_backend_config = {
    name = "backend"
    image = "gcr.io/adk-proyecto-desarrollo-999/adk-agent:dev" # Imagen DEV
    cpu = 1                 
    memory = "1Gi"          # Baja capacidad
    timeout_seconds = 300   
    concurrency = 10        # Baja concurrencia
}

# --------------------------------------------------------------------------------------
# 4. CONFIGURACIÓN DE BUCKETS
# --------------------------------------------------------------------------------------

gcs_bucket_config = {
    "input_a" : { 
        name_suffix = "input-a", 
        role_for_agent = "roles/storage.objectAdmin", 
        force_destroy = true # PERMITE BORRAR EL CONTENIDO RÁPIDAMENTE
    },
    "output" : { 
        name_suffix = "output",  
        role_for_agent = "roles/storage.objectCreator", 
        force_destroy = true 
    },
}