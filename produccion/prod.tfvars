# prod.tfvars
# VALORES DE CONFIGURACIÓN PARA EL ENTORNO DE PRODUCCIÓN (PROD)

# --------------------------------------------------------------------------------------
# 1. METADATOS CLAVE
# --------------------------------------------------------------------------------------

project_id = "adk-proyecto-produccion-001" 
region     = "us-east4" # Región con baja latencia para el cliente final
application_name = "adk" 
application_display_name = "Agente de Conocimiento ADK"
environment = "prod" # Prefijo resultante: adk-prod

# --------------------------------------------------------------------------------------
# 2. CONFIGURACIÓN DE IDENTIDAD Y DATOS
# --------------------------------------------------------------------------------------

sa_account_id = "adk-prod-processor-sa" 
firestore_location_id = "nam5" # CRÍTICO: Debe coincidir con la ubicación de Firestore DB
rag_index_dimensions = 768

# --------------------------------------------------------------------------------------
# 3. CONFIGURACIÓN DE COMPUTE (CLOUD RUN)
# --------------------------------------------------------------------------------------

agent_backend_config = {
    name = "backend"
    image = "gcr.io/adk-proyecto-produccion-001/adk-agent:latest" # Imagen estable
    cpu = 2                 # Alta capacidad
    memory = "4Gi"          # Alta capacidad
    timeout_seconds = 900   
    concurrency = 80        # Alta concurrencia
}

# --------------------------------------------------------------------------------------
# 4. CONFIGURACIÓN DE BUCKETS
# --------------------------------------------------------------------------------------

gcs_bucket_config = {
    "input_a" : { 
        name_suffix = "input-a", 
        role_for_agent = "roles/storage.objectAdmin", 
        force_destroy = false # ¡IMPORTANTE! Protección de datos
    },
    "output" : { 
        name_suffix = "output",  
        role_for_agent = "roles/storage.objectCreator", 
        force_destroy = false 
    },
}