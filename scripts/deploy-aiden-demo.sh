#!/usr/bin/env bash
# Build (optional), apply ad-service to aiden-demo, refresh Datadog log tail config.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="${NAMESPACE:-aiden-demo}"
IMAGE="${IMAGE:-ghcr.io/stackgen-demo/ad-service:latest}"
PUSH="${PUSH:-false}"

cd "$ROOT"

if [[ "$PUSH" == "true" ]]; then
  echo "==> docker build + push $IMAGE"
  docker buildx build --platform linux/amd64,linux/arm64 -t "$IMAGE" --push .
fi

echo "==> apply datadog log config (aiden-demo workloads)"
kubectl apply -f k8s/datadog-logs-config.yaml
kubectl -n "$NAMESPACE" rollout restart deployment/datadog-agent
kubectl -n "$NAMESPACE" rollout status deployment/datadog-agent --timeout=120s

echo "==> apply ad-service"
kubectl apply -f k8s/ad-service.yaml
kubectl -n "$NAMESPACE" rollout status deployment/ad-service --timeout=180s

kubectl -n "$NAMESPACE" get pods -l 'app in (aiden-demo,ad-service,datadog-agent)' -o wide
echo "ad-service deployed. Datadog: service:ad-service env:demo"
