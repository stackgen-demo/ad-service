# Standalone ad-service image for aiden-demo (gRPC + OpenTelemetry Java agent).
# Copyright The OpenTelemetry Authors — SPDX-License-Identifier: Apache-2.0

FROM --platform=$BUILDPLATFORM eclipse-temurin:21-jdk AS builder

WORKDIR /usr/src/app/

COPY gradlew settings.gradle build.gradle ./
COPY gradle ./gradle
RUN chmod +x ./gradlew && ./gradlew downloadRepos

COPY src ./src
COPY pb ./proto
RUN ./gradlew installDist -PprotoSourceDir=./proto

FROM eclipse-temurin:21-jre-jammy

ARG OTEL_JAVA_AGENT_VERSION=2.22.0

WORKDIR /usr/src/app/

COPY --from=builder /usr/src/app/build/install/opentelemetry-demo-ad /usr/src/app/
ADD --chmod=644 https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_JAVA_AGENT_VERSION}/opentelemetry-javaagent.jar /usr/src/app/opentelemetry-javaagent.jar

ENV JAVA_TOOL_OPTIONS=-javaagent:/usr/src/app/opentelemetry-javaagent.jar
ENV AD_PORT=8080
ENV OTEL_SERVICE_NAME=ad-service

EXPOSE 8080

ENTRYPOINT ["/usr/src/app/bin/Ad"]
