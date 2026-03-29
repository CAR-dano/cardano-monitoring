# Prometheus scrape secrets

Create the bearer token file required by `prometheus.yml`:

```bash
mkdir -p deploy/metrics/secrets
printf '%s' "<METRICS_BEARER_TOKEN>" > deploy/metrics/secrets/metrics_bearer_token
```

Notes:

- File path must be exactly: `deploy/metrics/secrets/metrics_bearer_token`
- Do not commit real secret values.
