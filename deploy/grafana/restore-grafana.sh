#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <backup-directory>"
  exit 1
fi

BACKUP_DIR="$1"

if [[ ! -d "${BACKUP_DIR}" ]]; then
  echo "Backup directory not found: ${BACKUP_DIR}"
  exit 1
fi

echo "Restoring provisioned files..."
rm -rf ./provisioning
cp -R "${BACKUP_DIR}/provisioning" ./provisioning

if [[ -f "${BACKUP_DIR}/grafana-data.tar.gz" ]]; then
  echo "Restoring Grafana persistent volume..."
  docker run --rm \
    -v grafana_grafana-data:/var/lib/grafana \
    -v "$(cd "${BACKUP_DIR}" && pwd):/backup:ro" \
    alpine:3.20 \
    sh -c 'rm -rf /var/lib/grafana/* && tar xzf /backup/grafana-data.tar.gz -C /var/lib/grafana'
fi

echo "Restore completed from ${BACKUP_DIR}"
