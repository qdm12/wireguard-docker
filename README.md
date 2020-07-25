# Wireguard Docker

13MB Docker image to run Wireguard commands (`wg` and `wg-quick`) with iptables.

Built for amd64, 386, ARM and s390x CPU architectures.

## Setup

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
