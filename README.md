# Ad Service

gRPC ad service for the **aiden-demo** namespace on EKS. Ships OTLP traces and logs via the OpenTelemetry Java agent to the shared Datadog agent (US3), same pattern as [order-service](https://github.com/stackgen-demo/order-service).

Service name in Datadog: **`ad-service`**

The Ad service provides advertisement based on context keys. If no context keys are provided then it returns random ads.

## Local run

Requires JDK 21+:

```bash
./gradlew installDist -PprotoSourceDir=./pb
export AD_PORT=8080
./build/install/opentelemetry-demo-ad/bin/Ad
```

## Container image (GHCR)

Push to `initial-setup` or `main` runs [`.github/workflows/docker-publish.yml`](.github/workflows/docker-publish.yml):

`ghcr.io/stackgen-demo/ad-service:latest`

Make the GHCR package **public** after the first CI run (Packages → ad-service → Change visibility).

## Deploy to aiden-demo

**Prerequisites:** [order-service](https://github.com/stackgen-demo/order-service) stack applied, `datadog-secret` present, and OTLP enabled on the agent:

```bash
kubectl -n aiden-demo set env deployment/datadog-agent \
  DD_OTLP_CONFIG_RECEIVER_PROTOCOLS_GRPC_ENDPOINT=0.0.0.0:4317
```

```bash
# After CI publishes the image (or local build):
PUSH=true ./scripts/deploy-aiden-demo.sh
# Or apply manifests only:
./scripts/deploy-aiden-demo.sh
```

## Datadog

- APM: `service:ad-service env:demo`
- gRPC port **8080** (`ad-service.aiden-demo.svc:8080`)

## Docker build (local)

```bash
docker build -t ad-service:local .
```

Protobuf definitions live in [`pb/demo.proto`](pb/demo.proto) (vendored from the OpenTelemetry Astronomy Shop demo).

## Upgrading Gradle

```bash
./gradlew wrapper --gradle-version <new-version>
```
