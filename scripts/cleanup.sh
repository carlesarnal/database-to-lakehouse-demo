#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."

echo "Tearing down all services..."
docker compose -f "$PROJECT_DIR/docker-compose.yaml" down -v

echo "Cleanup complete."
