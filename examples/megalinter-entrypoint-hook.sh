#!/bin/sh
set -eu

MEGALINTER_RUNTIME_UID="${MEGALINTER_UID:-}"
MEGALINTER_RUNTIME_GID="${MEGALINTER_GID:-}"
MEGALINTER_RUNTIME_USER="${MEGALINTER_USER:-megalinter}"
MEGALINTER_RUNTIME_HOME="${HOME:-/home/${MEGALINTER_RUNTIME_USER}}"

if [ "$(id -u)" -eq 0 ] \
  && [ -n "${MEGALINTER_RUNTIME_UID}" ] \
  && [ -n "${MEGALINTER_RUNTIME_GID}" ] \
  && [ "${CHU_USER_SWITCHED:-0}" != "1" ]; then
  export CHU_UID="${MEGALINTER_RUNTIME_UID}"
  export CHU_GID="${MEGALINTER_RUNTIME_GID}"
  export CHU_USER="${MEGALINTER_RUNTIME_USER}"
  export CHU_HOME="${MEGALINTER_RUNTIME_HOME}"
  exec /usr/local/bin/container-host-user /entrypoint.sh "$@"
fi

exec /entrypoint.sh "$@"
