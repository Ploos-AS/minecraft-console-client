# syntax=docker/dockerfile:1.7

ARG MCC_VERSION=20260829-511

FROM alpine:3.22 AS fetch

ARG TARGETARCH
ARG MCC_VERSION

RUN apk add --no-cache ca-certificates curl

RUN set -eux; \
    case "$TARGETARCH" in \
      amd64) \
        asset_arch="x64"; \
        expected_sha256="2e0fe135079824d1b02a3ef9bf89c56d95d72a1d1502d7204f93acc0084223db" \
        ;; \
      arm64) \
        asset_arch="arm64"; \
        expected_sha256="305dc0766df3509008cc00bb4ebd6be8246f01aff7b84409e0856a98fb759925" \
        ;; \
      *) \
        echo "Unsupported architecture: $TARGETARCH" >&2; \
        exit 1 \
        ;; \
    esac; \
    url="https://github.com/MCCTeam/Minecraft-Console-Client/releases/download/$MCC_VERSION/MinecraftClient-$MCC_VERSION-linux-$asset_arch"; \
    curl --fail --location --retry 3 --output /MinecraftClient "$url"; \
    echo "$expected_sha256  /MinecraftClient" | sha256sum -c -; \
    chmod 0755 /MinecraftClient

FROM alpine:3.22

ARG MCC_VERSION=20260829-511
ARG VERSION=dev
ARG REVISION=unknown

LABEL org.opencontainers.image.title="Ploos-AS Minecraft Console Client" \
      org.opencontainers.image.description="Ready-to-run Minecraft Console Client container" \
      org.opencontainers.image.source="https://github.com/Ploos-AS/minecraft-console-client" \
      org.opencontainers.image.url="https://github.com/Ploos-AS/minecraft-console-client" \
      org.opencontainers.image.version="$VERSION" \
      org.opencontainers.image.revision="$REVISION" \
      org.opencontainers.image.licenses="GPL-3.0-or-later" \
      io.ploos.mcc.upstream.version="$MCC_VERSION"

RUN addgroup -g 1000 mcc \
    && adduser -D -u 1000 -G mcc -h /opt/data mcc \
    && mkdir -p /opt/data \
    && chown -R mcc:mcc /opt/data

COPY --from=fetch --chown=mcc:mcc /MinecraftClient /usr/local/bin/MinecraftClient

WORKDIR /opt/data
USER mcc

VOLUME ["/opt/data"]

ENTRYPOINT ["/usr/local/bin/MinecraftClient"]
