#!/bin/bash
set -euo pipefail

REGISTRY_URL="${REGISTRY_URL:-http://localhost:8080}"
ICEBERG_API="$REGISTRY_URL/apis/iceberg/v1/default"
NS_ENCODED="lakehouse%1Finventory"

echo "Creating Iceberg namespace and tables via Apicurio Registry..."

echo "--- Creating namespace 'lakehouse.inventory' ---"
curl -s -X POST "$ICEBERG_API/namespaces" \
  -H "Content-Type: application/json" \
  -d '{"namespace": ["lakehouse", "inventory"]}'
echo ""

echo "--- Creating 'customers' table ---"
curl -s -X POST "$ICEBERG_API/namespaces/$NS_ENCODED/tables" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "customers",
    "schema": {
      "type": "struct",
      "schema-id": 0,
      "fields": [
        {"id": 1, "name": "id", "type": "int", "required": false},
        {"id": 2, "name": "first_name", "type": "string", "required": false},
        {"id": 3, "name": "last_name", "type": "string", "required": false},
        {"id": 4, "name": "email", "type": "string", "required": false}
      ]
    }
  }'
echo ""

echo "--- Creating 'orders' table ---"
curl -s -X POST "$ICEBERG_API/namespaces/$NS_ENCODED/tables" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "orders",
    "schema": {
      "type": "struct",
      "schema-id": 0,
      "fields": [
        {"id": 1, "name": "order_number", "type": "int", "required": false},
        {"id": 2, "name": "order_date", "type": "int", "required": false},
        {"id": 3, "name": "customer_id", "type": "int", "required": false},
        {"id": 4, "name": "quantity", "type": "int", "required": false},
        {"id": 5, "name": "price", "type": "double", "required": false}
      ]
    }
  }'
echo ""
echo "Tables created."
