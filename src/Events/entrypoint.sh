#!/bin/bash

# The rest...

mkdir -p /etc/bitwarden/core
mkdir -p /etc/bitwarden/logs
mkdir -p /etc/bitwarden/ca-certificates

if [[ $globalSettings__selfHosted == "true" ]]; then
    cp /etc/bitwarden/ca-certificates/*.crt /usr/local/share/ca-certificates/ >/dev/null 2>&1 &&
        update-ca-certificates
fi

exec dotnet /app/Events.dll
