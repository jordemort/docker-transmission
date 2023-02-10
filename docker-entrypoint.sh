#!/usr/bin/env bash

set -euo pipefail

PUID=${PUID:-1000}
PGID=${PGID:-1000}

exec dumb-init gosu "$PUID:$PGID" "$@"
