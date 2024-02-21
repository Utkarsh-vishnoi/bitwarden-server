#!/bin/bash

# The rest...
mkdir -p /bitwarden/env
mkdir -p /bitwarden/docker
mkdir -p /bitwarden/ssl
mkdir -p /bitwarden/letsencrypt
mkdir -p /bitwarden/identity
mkdir -p /bitwarden/nginx
mkdir -p /bitwarden/ca-certificates

cp /bitwarden/ca-certificates/*.crt /usr/local/share/ca-certificates/ >/dev/null 2>&1 &&
    update-ca-certificates

exec "$@"
