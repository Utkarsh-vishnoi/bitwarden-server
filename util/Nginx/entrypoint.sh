#!/bin/bash

# The rest...

cp /etc/bitwarden/nginx/*.conf /etc/nginx/conf.d/
mkdir -p /etc/letsencrypt
mkdir -p /etc/ssl
mkdir -p /var/run/nginx
touch /var/run/nginx/nginx.pid

# Launch a loop to rotate nginx logs on a daily basis
/bin/sh -c "/logrotate.sh loop >/dev/null 2>&1 &"

exec nginx -g 'daemon off;'
