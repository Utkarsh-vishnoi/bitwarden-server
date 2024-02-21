#!/bin/bash

# The rest...

mkdir -p /etc/bitwarden/core/attachments

exec dotnet /bitwarden_server/Server.dll \
    /contentRoot=/etc/bitwarden/core/attachments /webRoot=. /serveUnknown=true
