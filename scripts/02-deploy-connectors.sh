#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."

echo "=========================================="
echo "  Step 2: Deploy Kafka Connectors"
echo "=========================================="
echo ""

echo "--- Deploying Debezium PostgreSQL source connector ---"
curl -sf -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @"$PROJECT_DIR/connectors/debezium-source.json" | jq .
echo ""

echo "Waiting for Debezium to capture initial snapshot..."
sleep 10

echo "--- Deploying Iceberg sink connector ---"
curl -sf -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d @"$PROJECT_DIR/connectors/iceberg-sink.json" | jq .
echo ""

echo "--- Connector status ---"
echo "Source:"
curl -sf http://localhost:8083/connectors/inventory-source/status | jq '.connector.state'
echo "Sink:"
curl -sf http://localhost:8083/connectors/iceberg-sink/status | jq '.connector.state'
echo ""

echo "--- Schemas registered in Apicurio Registry ---"
curl -sf "http://localhost:8080/apis/registry/v3/search/artifacts" | jq '.artifacts[].artifactId'
echo ""

echo "Connectors deployed. CDC events are flowing."
echo "  Debezium: PostgreSQL → Kafka (Avro, schemas in Apicurio Registry)"
echo "  Iceberg:  Kafka → Iceberg tables (via REST catalog on MinIO)"
