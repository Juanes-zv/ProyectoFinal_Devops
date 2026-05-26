#!/bin/bash

# --- Script de Despliegue DevOps: Todo-API ---
# Uso: chmod +x deploy.sh && ./deploy.sh

echo "🚀 Iniciando despliegue de infraestructura..."

# 1. Aplicar ConfigMap
kubectl apply -f k8s/configmap.yml
kubectl apply -f k8s/prometheus-configmap.yml

# 2. Aplicar Deployments
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/prometheus-deployment.yml
kubectl apply -f k8s/grafana-deployment.yml

# 3. Aplicar Services
kubectl apply -f k8s/service.yml

echo "✅ Despliegue finalizado."
echo "------------------------------------------------"
echo "🔍 Acceso a los servicios:"
echo "API:       http://localhost (o IP del LB)"
echo "Prometheus: http://localhost:9090"
echo "Grafana:    http://localhost:3000 (admin/admin)"
echo "------------------------------------------------"
