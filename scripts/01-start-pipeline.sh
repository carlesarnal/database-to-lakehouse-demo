#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."

echo "=========================================="
echo "  Step 1: Start the Pipeline"
echo "=========================================="
echo ""

echo "Starting all services with Docker Compose..."
docker compose -f "$PROJECT_DIR/docker-compose.yaml" up -d --build

echo ""
"$SCRIPT_DIR/wait-for-services.sh"

echo ""
echo "Pipeline infrastructure is running."
echo "  PostgreSQL:        localhost:5432"
echo "  Kafka:             localhost:9092"
echo "  Kafka Connect:     localhost:8083"
echo "  Apicurio Registry: localhost:8080"
echo "  Registry UI:       localhost:8888"
echo "  MinIO Console:     localhost:9001  (admin/password)"
echo "  Iceberg REST:      localhost:8181"
echo "  Trino:             localhost:8084"
