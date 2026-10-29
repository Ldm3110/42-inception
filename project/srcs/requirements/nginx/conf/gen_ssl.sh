#!/bin/bash
set -e

source /run/secrets/credentials

# Default domain if not provided
: "${DOMAIN_NAME:=localhost}"
export DOMAIN_NAME   

SSL_DIR=/etc/nginx/ssl
CRT="$SSL_DIR/nginx.crt"
KEY="$SSL_DIR/nginx.key"

# Generate SSL certificate if it doesn't exist
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Generating self-signed SSL certificate for ${DOMAIN_NAME}..."

	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout "$KEY" -out "$CRT" \
		-subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=${DOMAIN_NAME}"

	chmod 600 "$KEY"
	chmod 644 "$CRT" 

	echo "SSL certificate generated at $SSL_DIR"
else
    echo "SSL certificate already exists. Skipping generation."
fi

envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Test nginx configuration before starting
echo "Testing nginx configuration..."
nginx -t
echo "Nginx configuration test passed."

# Start nginx in foreground (PID 1)
echo "Starting Nginx..."
exec nginx -g "daemon off;"
