# Guía del Proyecto DevOps

## 1. Pipeline CI/CD
El pipeline se encuentra en `.github/workflows/ci-cd.yml` y realiza las siguientes acciones:
- Linting con `flake8`.
- Auditoría de dependencias con `pip-audit`.
- Pruebas unitarias con `pytest`.
- Construcción de imagen Docker multi-stage.
- Publicación de la imagen en GitHub Container Registry (GHCR) con versionado dinámico (SHA del commit).

## 2. Estrategia de Branching
Seguimos una estrategia de ramas basada en características:
- `main`: Rama protegida para producción.
- `feature/*`: Ramas de trabajo para nuevas funcionalidades o correcciones.
- Los Pull Requests a `main` ejecutan automáticamente todo el pipeline.

## 3. Observabilidad
La API incluye:
- Logs estructurados en formato JSON.
- Endpoint `/health`: Verifica el estado de la conexión a la base de datos.
- Endpoint `/metrics`: Expone métricas para Prometheus.

### Observabilidad Avanzada (Prometheus y Grafana)
Se incluye todo el stack de observabilidad en el `docker-compose.yml`:
- **Prometheus**: Recolecta métricas automáticamente de la API. Acceso: `http://localhost:9090`
- **Grafana**: Visualización de métricas. Acceso: `http://localhost:3000` (usuario: `admin`, contraseña: `admin`).
