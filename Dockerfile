ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION}
ARG VERSION
ARG BUILD_DATE
ARG VCS_REF
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.url="https://github.com/qdm12/wireguard-docker" \
    org.opencontainers.image.documentation="https://github.com/qdm12/wireguard-docker" \
    org.opencontainers.image.source="https://github.com/qdm12/wireguard-docker" \
    org.opencontainers.image.title="Small container to run Wireguard commands for your host" \
    org.opencontainers.image.description="Small container to run Wireguard commands for your host"
RUN apk add --no-cache -q --progress --update wireguard-tools iptables
