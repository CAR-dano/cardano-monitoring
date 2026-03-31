#!/usr/bin/env bash
set -euo pipefail

BACKUP_ROOT="${BACKUP_ROOT:-./backups/grafana}"
STAMP="$(date +%Y%m%d-%H%M%S)"
OUT_DIR="${BACKUP_ROOT}/${STAMP}"

mkdir -p "${OUT_DIR}"

echo "Exporting provisioned dashboard and datasource definitions..."
cp -R ./provisioning "${OUT_DIR}/provisioning"

echo "Archiving Grafana persistent volume (if exists)..."
docker run --rm \
  -v grafana_grafana-data:/var/lib/grafana:ro \
  -v "$(pwd)/${OUT_DIR}:/backup" \
  alpine:3.20 \
  sh -c 'tar czf /backup/grafana-data.tar.gz -C /var/lib/grafana . || true'

echo "Backup completed at ${OUT_DIR}"
