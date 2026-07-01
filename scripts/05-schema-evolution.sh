#!/bin/bash
set -euo pipefail

echo "=========================================="
echo "  Step 5: Schema Evolution"
echo "=========================================="
echo ""

echo "--- Current Iceberg schema ---"
docker exec -i lakehouse-trino trino --execute \
  "DESCRIBE iceberg.inventory.customers;"
echo ""

echo "--- Adding 'phone' column in PostgreSQL ---"
docker exec -i lakehouse-postgres psql -U postgres -c \
  "ALTER TABLE inventory.customers ADD COLUMN phone VARCHAR(20);"
echo ""

echo "--- Inserting data with the new column ---"
docker exec -i lakehouse-postgres psql -U postgres -c \
  "UPDATE inventory.customers SET phone = '+34-555-0001' WHERE id = 1005;"
echo ""

echo "Waiting for schema propagation (Debezium → Registry → Iceberg)..."
sleep 8

echo ""
echo "--- New schema version in Apicurio Registry ---"
curl -sf "http://localhost:8080/apis/registry/v3/search/artifacts" | \
  jq '.artifacts[] | select(.artifactId | contains("customers")) | {artifactId, modifiedOn}'
echo ""

echo "--- Evolved Iceberg schema ---"
docker exec -i lakehouse-trino trino --execute \
  "DESCRIBE iceberg.inventory.customers;"
echo ""

echo "--- Query the new column ---"
docker exec -i lakehouse-trino trino --execute \
  "SELECT id, first_name, last_name, phone FROM iceberg.inventory.customers WHERE id = 1005;"
echo ""

echo "What just happened automatically:"
echo "  1. PostgreSQL schema changed (ALTER TABLE ADD COLUMN)"
echo "  2. Debezium detected the change, published events with the new field"
echo "  3. Apicurio Registry registered a new schema version (BACKWARD compatible)"
echo "  4. Iceberg sink connector evolved the table DDL — no manual ALTER needed"
