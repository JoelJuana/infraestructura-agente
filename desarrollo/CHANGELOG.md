# CHANGELOG

## [Unreleased] - 2025-11-24

### 🏗️ Reestructuración y Modularización
*   **Creación de Módulos:** Se ha dividido la infraestructura monolítica en tres módulos especializados en `modules/`:
    *   `iam-roles`: Centraliza la gestión de Service Accounts, APIs y permisos IAM.
    *   `data-layer`: Gestiona el almacenamiento (GCS), bases de datos (Firestore) e índices vectoriales (Vertex AI).
    *   `compute-backend`: Define los servicios de Cloud Run (Backend y Frontend).
*   **Refactorización del Root Module:** El archivo `main.tf` raíz ahora actúa como orquestador, invocando a los módulos y pasando variables.
*   **Uso de Locals:** Se ha implementado lógica en `locals` para la generación consistente de nombres de recursos (ej. buckets), eliminando duplicidad y dependencias cíclicas entre módulos.

### 🛡️ Seguridad y Estándares
*   **Protección de Datos en Producción:** Se ha creado el archivo `prod.tfvars` asegurando que `force_destroy = false` para los buckets de GCS, previniendo la pérdida accidental de datos.
*   **Gestión del Estado:** Se ha configurado el bloque `backend "gcs"` en `versions.tf` para permitir la gestión remota del estado de Terraform.
*   **Principio de Mínimo Privilegio:** La asignación de roles se ha encapsulado en el módulo `iam-roles`, facilitando la auditoría y el control de accesos.

### 🚀 Impacto en el Plan
*   La estructura ahora es escalable y mantenible.
*   La separación de responsabilidades permite cambios aislados en componentes específicos sin riesgo de afectar a toda la infraestructura.
*   La validación de seguridad está integrada en la configuración de producción.
