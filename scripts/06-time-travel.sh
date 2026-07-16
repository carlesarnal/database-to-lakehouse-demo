#!/bin/bash
set -euo pipefail

echo "=========================================="
echo "  Step 6: Iceberg Time Travel"
echo "=========================================="
echo ""

echo "--- All snapshots ---"
docker exec -i lakehouse-trino trino --execute \
  "SELECT snapshot_id, committed_at, operation, summary FROM iceberg.lakehouse.\"customers\$snapshots\" ORDER BY committed_at;"
echo ""

FIRST_SNAPSHOT=$(docker exec -i lakehouse-trino trino --output-format CSV --execute \
  "SELECT snapshot_id FROM iceberg.lakehouse.\"customers\$snapshots\" ORDER BY committed_at LIMIT 1;" 2>/dev/null | tr -d '"')

if [ -n "$FIRST_SNAPSHOT" ]; then
  echo "--- Querying first snapshot ($FIRST_SNAPSHOT) — before Alice was added ---"
  docker exec -i lakehouse-trino trino --execute \
    "SELECT * FROM iceberg.lakehouse.customers FOR VERSION AS OF $FIRST_SNAPSHOT;"
  echo ""
fi

echo "--- Current state ---"
docker exec -i lakehouse-trino trino --execute \
  "SELECT * FROM iceberg.lakehouse.customers ORDER BY id;"
echo ""

echo "Every CDC event creates an Iceberg snapshot."
echo "You can query the data as it was at any point in time."
echo "Useful for: ML training on historical data, auditing, debugging."
