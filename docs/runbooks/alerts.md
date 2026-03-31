# Alert Runbooks

This page is referenced by alert annotations as `runbook_url`.

## High Error Rate

- Check `http_request_errors_total` by `route` and `status_class`.
- Verify recent deploys and upstream dependency failures.
- Correlate traces in Jaeger for failing routes.

## High P95 Latency

- Inspect latency by route and compare with error spikes.
- Check DB span durations and external call timings.
- Review resource saturation (CPU/memory/disk) during spike windows.

## High Memory Usage

- Identify top memory-consuming workloads.
- Verify memory limits/requests and recent rollout changes.
- Restart only if memory leak confirmed and mitigation exists.

## Low Disk Space

- Check `/` usage growth trend and largest directories.
- Rotate/compact logs and clean stale artifacts.
- Expand storage if growth is sustained.

## Service Unavailable

- Confirm service process/container state.
- Check ingress/network and dependency health.
- Restore service, then perform post-incident review.
