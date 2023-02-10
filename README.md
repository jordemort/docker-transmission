# docker-transmission

This is a container for [Transmission](https://github.com/transmission/transmission).
It is built from source and uses `debian:bullseye-slim` as a base image.

Currently, it includes Transmission 4.0.0.

I made this because I was too impatient to wait for LinuxServer.io to update their container.

This is a very vanilla build. It is set up to act somewhat like the LinuxServer container.

| Environment variable | Description | Default |
|----------------------|-------------|---------|
| `PUID` | User ID to run as | 1000 |
| `PGID` | Group ID to run as | 1000 |

| Mount point | Purpose |
|-------------|---------|
| `/config` | Transmission configuration - mount something here and persist this between runs! |
| `/downloads` | Downloaded files |
| `/watch` | "Blackhole" directory - any `.torrent` or `.magnet` files placed here will be downloaded |
