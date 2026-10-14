#!/bin/bash
set -e

# Required variables (fail early with a clear message if missing)
: "${DB_HOST:=mariadb}"
: "${DB_NAME:?DB_NAME is required}"
: "${DB_USER:?DB_USER is required}"
: "${DB_PASSWORD:?DB_PASSWORD is required}"
: "${DOMAIN_NAME:?DOMAIN_NAME is required}"
: "${WP_TITLE:?WP_TITLE is required}"
: "${WP_ADMIN_USER:?WP_ADMIN_USER is required}"
: "${WP_ADMIN_PASSWORD:?WP_ADMIN_PASSWORD is required}"
: "${WP_ADMIN_EMAIL:?WP_ADMIN_EMAIL is required}"
: "${WP_USER:?WP_USER is required}"
: "${WP_USER_PASSWORD:?WP_USER_PASSWORD is required}"
: "${WP_USER_EMAIL:?WP_USER_EMAIL is required}"

cd /var/www/html

# Wait until MariaDB accepts TCP connections
echo "Waiting for MariaDB at ${DB_HOST}:3306..."
until (echo > "/dev/tcp/${DB_HOST}/3306") 2>/dev/null; do
    sleep 2
done
echo "MariaDB is reachable."

# Download WordPress into the (possibly empty) volume
if [ ! -f wp-settings.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

# Create wp-config.php
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASSWORD" \
        --dbhost="${DB_HOST}:3306" \
        --allow-root
fi

# Install WordPress and create the second user (only once)
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --role=author \
        --allow-root
fi

# php-fpm runs as www-data and must be able to write (uploads, plugins)
chown -R www-data:www-data /var/www/html

# Start php-fpm in foreground (PID 1)
echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
