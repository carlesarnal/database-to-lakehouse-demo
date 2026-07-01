#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=================================================="
echo "  From Database to Lakehouse in Real-Time"
echo "  CDC → Kafka → Apicurio → Iceberg"
echo "=================================================="
echo ""
echo "Prerequisites: Docker and Docker Compose"
echo ""

read -p "Press Enter to start..." _

echo ""
"$SCRIPT_DIR/01-start-pipeline.sh"
echo ""
read -p "Press Enter to deploy connectors..." _

echo ""
"$SCRIPT_DIR/02-deploy-connectors.sh"
echo ""
read -p "Press Enter to insert data..." _

echo ""
"$SCRIPT_DIR/03-insert-data.sh"
echo ""
echo "Waiting 10 seconds for CDC propagation..."
sleep 10
read -p "Press Enter to query Iceberg..." _

echo ""
"$SCRIPT_DIR/04-query-iceberg.sh"
echo ""
read -p "Press Enter for schema evolution demo..." _

echo ""
"$SCRIPT_DIR/05-schema-evolution.sh"
echo ""
read -p "Press Enter for time travel demo..." _

echo ""
"$SCRIPT_DIR/06-time-travel.sh"

echo ""
echo "=================================================="
echo "  Demo complete!"
echo ""
echo "  Key takeaways:"
echo "  1. Sub-second latency from DB commit to Iceberg"
echo "  2. Schema evolution flows automatically end-to-end"
echo "  3. Time travel queries via Iceberg snapshots"
echo "  4. Apicurio Registry is the contract layer"
echo "  5. 100% open source — no vendor lock-in"
echo "=================================================="
echo ""
echo "Run ./cleanup.sh to tear down all services."
