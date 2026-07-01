#!/bin/bash
set -euo pipefail

echo "=========================================="
echo "  Step 3: Insert Data into PostgreSQL"
echo "=========================================="
echo ""

echo "--- Inserting a new customer ---"
docker exec -i lakehouse-postgres psql -U postgres -c \
  "INSERT INTO inventory.customers VALUES (1005, 'Alice', 'Smith', 'alice@example.com');"
echo ""

echo "--- Inserting a new order ---"
docker exec -i lakehouse-postgres psql -U postgres -c \
  "INSERT INTO inventory.orders VALUES (10005, '2024-07-01', 1005, 3, 99.99);"
echo ""

echo "Data inserted. CDC events are flowing through Kafka to Iceberg."
echo "Wait a few seconds for propagation, then run 04-query-iceberg.sh"
