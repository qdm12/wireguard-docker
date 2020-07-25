# Wireguard Docker

13MB Docker image to run Wireguard commands (`wg` and `wg-quick`) with iptables.

Built for amd64, 386, ARM and s390x CPU architectures.

[![Build status](https://github.com/qdm12/wireguard-docker/workflows/Buildx%20latest/badge.svg)](https://github.com/qdm12/wireguard-docker/actions?query=workflow%3A%22Buildx+latest%22)
[![Docker Pulls](https://img.shields.io/docker/pulls/qmcgaw/wireguard.svg)](https://hub.docker.com/r/qmcgaw/wireguard)
[![Docker Stars](https://img.shields.io/docker/stars/qmcgaw/wireguard.svg)](https://hub.docker.com/r/qmcgaw/wireguard)

[![GitHub last commit](https://img.shields.io/github/last-commit/qdm12/wireguard-docker.svg)](https://github.com/qdm12/wireguard-docker/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/y/qdm12/wireguard-docker.svg)](https://github.com/qdm12/wireguard-docker/issues)
[![GitHub issues](https://img.shields.io/github/issues/qdm12/wireguard-docker.svg)](https://github.com/qdm12/wireguard-docker/issues)

[![Image size](https://images.microbadger.com/badges/image/qmcgaw/wireguard.svg)](https://microbadger.com/images/qmcgaw/wireguard)
[![Image version](https://images.microbadger.com/badges/version/qmcgaw/wireguard.svg)](https://microbadger.com/images/qmcgaw/wireguard)
[![Join Slack channel](https://img.shields.io/badge/slack-@qdm12-yellow.svg?logo=slack)](https://join.slack.com/t/qdm12/shared_invite/enQtOTE0NjcxNTM1ODc5LTYyZmVlOTM3MGI4ZWU0YmJkMjUxNmQ4ODQ2OTAwYzMxMTlhY2Q1MWQyOWUyNjc2ODliNjFjMDUxNWNmNzk5MDk)

## Setup

1. You need Wireguard in your Kernel. It comes [by default on Linux kernels >= 5.6](https://www.xda-developers.com/wireguard-vpn-linux-kernel-5-6/).
1. Get your host default interface

    ```sh
    route | grep '^default' | grep -o '[^ ]*$'
    ```

    For example, in my case it's `enp4s0`

1. Write your Wireguard configuration file in a file *wg0.conf*. For example:

    ```conf
    [Interface]
    Address = 192.168.10.1/24
    PostUp = /etc/wireguard/postup.sh %i enp4s0
    PostDown = /etc/wireguard/postdown.sh %i enp4s0
    ListenPort = 51820
    PrivateKey = xxxx

    [Peer]
    # A client
    PublicKey = 82VZZeEY4BUV1vQofV+CTSJoGAggwI47eSfow48HJG8=
    AllowedIPs = 192.168.10.2/32
    ```

    In this example we also add postup.sh and postdown.sh scripts which can contain iptables rules for example.

    For example, postup.sh could be:

    ```sh
    WG_INTF=$1
    DEFAULT_INTF=$2
    iptables -t nat -I POSTROUTING -o $DEFAULT_INTF -j MASQUERADE
    iptables -A FORWARD -i $WG_INTF -j ACCEPT
    iptables -A FORWARD -o $WG_INTF -j ACCEPT
    ```

    and postdown.sh:

    ```sh
    WG_INTF=$1
    DEFAULT_INTF=$2
    iptables -t nat -D POSTROUTING -o $DEFAULT_INTF -j MASQUERADE
    iptables -D FORWARD -i $WG_INTF -j ACCEPT
    iptables -D FORWARD -o $WG_INTF -j ACCEPT
    ```

1. Make the scripts executable

    ```sh
    chmod +x postup.sh postdown.sh
    ```

1. Enable the Wireguard interface with

    ```sh
    docker run -it --rm --cap-add=NET_ADMIN --network=host \
    -v "$(pwd)/wg0.conf":/etc/wireguard/wg0.conf:ro \
    -v "$(pwd)/postup.sh":/etc/wireguard/postup.sh:ro \
    -v "$(pwd)/postdown.sh":/etc/wireguard/postdown.sh:ro \
    qmcgaw/wireguard wg-quick up wg0
    ```

1. Disable it with

    ```sh
    docker run -it --rm --cap-add=NET_ADMIN --network=host \
    -v "$(pwd)/wg0.conf":/etc/wireguard/wg0.conf:ro \
    -v "$(pwd)/postup.sh":/etc/wireguard/postup.sh:ro \
    -v "$(pwd)/postdown.sh":/etc/wireguard/postdown.sh:ro \
    qmcgaw/wireguard wg-quick down wg0
    ```

    You can also use `docker-compose up` with the [docker-compose.yml](https://raw.githubusercontent.com/qdm12/wireguard-docker/master/docker-compose.yml) file, by changing the `command: ` line.

## Suggestions

👉 [Create an issue](https://github.com/qdm12/wireguard-docker/issues/new)

## License

License is of course an MIT license

## TODOs

- Get microbadger webhook link
