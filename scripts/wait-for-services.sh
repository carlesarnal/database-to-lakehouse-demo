#!/bin/bash
set -euo pipefail

echo "Waiting for services to be ready..."

wait_for() {
  local name="$1" url="$2"
  printf "  %-20s" "$name"
  until curl -sf "$url" > /dev/null 2>&1; do
    printf "."
    sleep 2
  done
  echo " ready"
}

wait_for "PostgreSQL"       "http://localhost:5432" 2>/dev/null || \
  until pg_isready -h localhost -p 5432 -U postgres > /dev/null 2>&1; do sleep 2; done && echo "  PostgreSQL           ready"

wait_for "Kafka Connect"    "http://localhost:8083/connectors"
wait_for "Apicurio Registry" "http://localhost:8080/apis/registry/v3/system/info"
wait_for "MinIO"            "http://localhost:9000/minio/health/live"
wait_for "Iceberg Catalog"  "http://localhost:8080/apis/iceberg/v1/config"
wait_for "Trino"            "http://localhost:8084/v1/info"

echo ""
echo "All services ready!"
