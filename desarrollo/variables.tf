# variables.tf

# --------------------------------------------------------------------------------------
# 1. VARIABLES BÁSICAS DEL PROYECTO
# --------------------------------------------------------------------------------------

variable "project_id" {
  description = "ID del proyecto de Google Cloud."
  type        = string
}

variable "region" {
  description = "Región principal de GCP."
  type        = string
  default     = "us-central1"
}

variable "application_name" {
  description = "Nombre corto e identificador único de la aplicación (ej: adk, crm). Se usa para prefijos."
  type        = string
  default     = "adk" 
}

variable "application_display_name" {
  description = "Nombre legible y largo de la aplicación (ej: Agente de Conocimiento ADK)."
  type        = string
  default     = "Agente ADK" 
}

variable "environment" {
  description = "Entorno (ej: dev, staging, prod)."
  type        = string
  default     = "dev"
}

# --------------------------------------------------------------------------------------
# 2. CONFIGURACIÓN DE IDENTIDAD Y DATOS
# --------------------------------------------------------------------------------------

variable "sa_account_id" {
  description = "ID único de la Cuenta de Servicio del procesador."
  type        = string
  default     = "rag-processor-sa"
}

variable "firestore_location_id" {
  description = "Ubicación crítica para la base de datos Firestore (ej: eur3, us-west1)."
  type        = string
  default     = "eur3"
}

variable "rag_index_dimensions" {
  description = "Dimensiones del índice de vectores de Vertex AI (768 para embeddings comunes)."
  type        = number
  default     = 768
}

variable "gcs_bucket_config" {
  description = "Configuración detallada para los buckets de GCS (nombre y permisos)."
  type = map(object({
    name_suffix     = string
    role_for_agent  = string
    force_destroy   = bool
  }))
  default = {
    "input_a" : { name_suffix = "input-a", role_for_agent = "roles/storage.objectAdmin", force_destroy = true },
    "output" :  { name_suffix = "output",  role_for_agent = "roles/storage.objectCreator", force_destroy = true },
  }
}

# --------------------------------------------------------------------------------------
# 3. CONFIGURACIÓN DE COMPUTE (CLOUD RUN)
# --------------------------------------------------------------------------------------

variable "agent_backend_config" {
  description = "Configuración de recursos para el servicio Cloud Run Backend."
  type = object({
    name = string
    image = string
    cpu = number
    memory = string
    timeout_seconds = number
    concurrency = number
  })
  default = {
    name = "backend" 
    image = "us-docker.pkg.dev/cloudrun/container/hello" 
    cpu = 1
    memory = "2Gi"
    timeout_seconds = 600
    concurrency = 50
  }
}