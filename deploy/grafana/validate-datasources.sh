#!/usr/bin/env bash
set -euo pipefail

GRAFANA_URL="${GRAFANA_URL:-http://localhost:3000}"
GRAFANA_ADMIN_USER="${GRAFANA_ADMIN_USER:-admin}"
GRAFANA_ADMIN_PASSWORD="${GRAFANA_ADMIN_PASSWORD:-change-me}"

auth=(-u "${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}")

echo "Checking provisioned datasources..."
datasources_json="$(curl -fsS "${auth[@]}" "${GRAFANA_URL}/api/datasources")"

echo "${datasources_json}" | grep -q '"uid":"prometheus"'
echo "${datasources_json}" | grep -q '"uid":"loki"'
echo "${datasources_json}" | grep -q '"uid":"jaeger"'

echo "Checking Prometheus datasource health..."
curl -fsS "${auth[@]}" "${GRAFANA_URL}/api/datasources/uid/prometheus/health" | grep -q '"status":"OK"'

echo "Checking Loki datasource health..."
curl -fsS "${auth[@]}" "${GRAFANA_URL}/api/datasources/uid/loki/health" | grep -q '"status":"OK"'

echo "Checking Jaeger datasource connectivity..."
curl -fsS "${auth[@]}" "${GRAFANA_URL}/api/datasources/proxy/uid/jaeger/api/services" >/dev/null

echo "All datasources are provisioned and reachable."
