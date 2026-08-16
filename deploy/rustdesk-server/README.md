# RigelDesk self-hosted server

This deployment runs the open-source RustDesk ID/rendezvous service (`hbbs`) and relay service (`hbbr`) for RigelDesk clients. It does not change the RigelDesk desktop engine or bundle any client credentials.

## Before first boot

Use a Linux VPS with Docker Engine and the Compose plugin installed. Point a DNS record at the VPS, then copy the example environment file:

```sh
cp .env.example .env
```

Set `RUSTDESK_PUBLIC_HOST` in `.env` to the public DNS name or IP that clients will use. Do not add a port to that value. The server advertises the relay as `<host>:21117`.

Keep `.env` and the generated `data/` directory private. The data directory contains the server identity key and rendezvous database. Back it up before upgrades; losing the private key changes the server identity and requires reconfiguring clients.

## Firewall

For the desktop client, allow these inbound ports:

| Port | Protocol | Purpose |
| --- | --- | --- |
| 21115 | TCP | NAT type test |
| 21116 | TCP and UDP | ID registration, heartbeat, and connection service |
| 21117 | TCP | Relay service |

Ports `21118` and `21119` are intentionally not exposed because they are only needed for the RustDesk web client. Caddy is not required for this desktop-only setup.

## Start and verify

Run these commands from this directory:

```sh
docker compose config
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 hbbs hbbr
```

The first start creates the server key in `data/id_ed25519.pub`. The public contents of that file will be used when we provision RigelDesk clients in the next phase. Never share `data/id_ed25519` or the full `data/` directory.

## Maintenance

Use a tested image tag in `RUSTDESK_SERVER_IMAGE` for production rather than silently tracking `latest`. Back up `data/`, then upgrade with:

```sh
docker compose pull
docker compose up -d
docker compose ps
```

If a service is unhealthy, inspect `docker compose logs hbbs hbbr` before changing configuration. Keep the VPS, Docker Engine, and firewall rules patched, and restrict SSH separately from the RustDesk ports.

## Next phase

After the VPS hostname and public key are confirmed, the RigelDesk client will be configured with the ID server and key. We will then test registration, direct connections, relay fallback, file transfer, and offline behavior with two release builds.
