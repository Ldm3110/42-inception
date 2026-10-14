FROM debian:bookworm
 
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        php8.2-fpm \
        php8.2-cli \
        php8.2-mysql \
        php8.2-curl \
        php8.2-gd \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        php8.2-intl \
        wget \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*
 
# WP-CLI: install as the "wp" command
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
        -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp
 
# /run/php is needed by php-fpm (pid file), /var/www/html is the shared volume
RUN mkdir -p /run/php /var/www/html && \
    chown -R www-data:www-data /var/www/html
 
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/setup_wp.sh /usr/local/bin/setup_wp.sh
RUN chmod +x /usr/local/bin/setup_wp.sh
 
WORKDIR /var/www/html
 
EXPOSE 9000
 
ENTRYPOINT ["/usr/local/bin/setup_wp.sh"]

