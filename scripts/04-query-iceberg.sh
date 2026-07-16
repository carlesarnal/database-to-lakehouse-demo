#!/bin/bash
set -euo pipefail

echo "=========================================="
echo "  Step 4: Query Iceberg Tables via Trino"
echo "=========================================="
echo ""

echo "--- Customers table ---"
docker exec -i lakehouse-trino trino --execute \
  "SELECT * FROM iceberg.lakehouse.customers ORDER BY id;"
echo ""

echo "--- Orders table ---"
docker exec -i lakehouse-trino trino --execute \
  "SELECT * FROM iceberg.lakehouse.orders ORDER BY order_number;"
echo ""

echo "--- Iceberg snapshots (time travel history) ---"
docker exec -i lakehouse-trino trino --execute \
  "SELECT snapshot_id, committed_at, operation FROM iceberg.lakehouse.\"customers\$snapshots\" ORDER BY committed_at;"
echo ""

echo "The data you inserted in PostgreSQL is already queryable in Iceberg."
echo "No batch job. No ETL scheduler. Sub-second latency."
