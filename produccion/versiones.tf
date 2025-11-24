# versions.tf

# Define la versión mínima de Terraform y los proveedores requeridos.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Configuración del proveedor de Google Cloud
provider "google" {
  project = var.project_id
  region  = var.region
}