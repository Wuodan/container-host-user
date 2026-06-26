#!/bin/sh
set -eu

# Test-only hook for an image that already has an existing /docker-entrypoint.sh.
# It applies container-host-user once and then returns to the original nginx
# entrypoint flow.

NGINX_RUNTIME_UID="${NGINX_UID:-}"
NGINX_RUNTIME_GID="${NGINX_GID:-}"
NGINX_RUNTIME_USER="${NGINX_USER:-nginxhost}"
NGINX_RUNTIME_HOME="${NGINX_HOME:-/home/${NGINX_RUNTIME_USER}}"

if [ "$(id -u)" -eq 0 ] \
  && [ -n "${NGINX_RUNTIME_UID}" ] \
  && [ -n "${NGINX_RUNTIME_GID}" ] \
  && [ "${CHU_USER_SWITCHED:-0}" != "1" ]; then
  export CHU_UID="${NGINX_RUNTIME_UID}"
  export CHU_GID="${NGINX_RUNTIME_GID}"
  export CHU_USER="${NGINX_RUNTIME_USER}"
  export CHU_HOME="${NGINX_RUNTIME_HOME}"
  exec /usr/local/bin/container-host-user /docker-entrypoint.sh "$@"
fi

exec /docker-entrypoint.sh "$@"
