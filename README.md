# Minecraft Console Client Container

Ready-to-run OCI image for [Minecraft Console Client](https://github.com/MCCTeam/Minecraft-Console-Client).

This repository packages the upstream MCC release as a small, reproducible container. It is not a fork of Minecraft Console Client.

## Image

`ghcr.io/ploos-as/minecraft-console-client`

The initial container release pins upstream MCC `20260829-511`.

Supported platforms:

- `linux/amd64`
- `linux/arm64`

## Quick start

```bash
mkdir -p data
docker run --rm -it \
  --name minecraft-console-client \
  -v "$PWD/data:/opt/data" \
  ghcr.io/ploos-as/minecraft-console-client:latest
```

For Compose:

```bash
docker compose run --rm mcc
```

The container deliberately defaults to interactive use because MCC is a console application and some configurations expect an attached terminal.

## Persistent data

MCC runs with `/opt/data` as its working directory. Configuration, session state and other MCC-created files therefore persist there.

The image runs as an unprivileged user with UID/GID `1000:1000`. For a bind mount, make sure the host directory is writable by UID 1000:

```bash
mkdir -p data
sudo chown 1000:1000 data
```

A named Docker volume can be used instead if you prefer Docker-managed permissions.

## Upstream version

The Docker build pins both the MCC release tag and the SHA-256 digest of the official upstream Linux binary for each architecture.

Current upstream release packaged by this repository:

`20260829-511`

Updating MCC is therefore an explicit repository change rather than a download of whatever happens to be `latest` when a container starts.

## Non-interactive operation

MCC supports automation, but not every MCC configuration behaves safely without an interactive console. If you intend to run the container permanently in the background, configure MCC accordingly and test that configuration before relying on unattended restarts.

## Security

The runtime image:

- runs unprivileged
- does not require the Docker socket
- does not require host networking
- does not require privileged mode
- drops all Linux capabilities in the supplied Compose configuration

## Upstream

Minecraft Console Client is developed by MCCTeam and contributors. This repository only packages upstream releases into an OCI image.

See the upstream project for MCC documentation, configuration and licensing.
