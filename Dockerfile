# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

# Adapted for standalone repository structure
FROM --platform=${BUILDPLATFORM} eclipse-temurin:21-jdk AS builder
ARG _JAVA_OPTIONS
ARG OTEL_JAVA_AGENT_VERSION=${OTEL_JAVA_AGENT_VERSION:-2.7.0}
WORKDIR /usr/src/app/

# Copy Gradle files
COPY ./gradlew* ./
COPY ./settings.gradle* ./
COPY ./build.gradle ./
COPY ./gradle ./gradle

RUN chmod +x ./gradlew
RUN ./gradlew
RUN ./gradlew downloadRepos

# Copy source files (adapted for standalone repo - files are at root level)
COPY ./src ./src
# Copy proto file if it exists in proto/ directory
COPY ./proto ./proto

RUN chmod +x ./gradlew
# Build with proto source directory
RUN ./gradlew installDist -PprotoSourceDir=./proto

# -----------------------------------------------------------------------------

FROM eclipse-temurin:21-jre

ARG OTEL_JAVA_AGENT_VERSION=${OTEL_JAVA_AGENT_VERSION:-2.7.0}
ARG _JAVA_OPTIONS

WORKDIR /usr/src/app/

COPY --from=builder /usr/src/app/ ./
ADD --chmod=644 https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_JAVA_AGENT_VERSION}/opentelemetry-javaagent.jar /usr/src/app/opentelemetry-javaagent.jar
ENV JAVA_TOOL_OPTIONS=-javaagent:/usr/src/app/opentelemetry-javaagent.jar

EXPOSE ${AD_PORT:-8080}
ENTRYPOINT [ "./build/install/opentelemetry-demo-ad/bin/Ad" ]
