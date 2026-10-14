FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

# install nginx package
RUN apt-get install -y \
	nginx \
	openssl\
	gettext-base &&\
	rm -rf /var/lib/apt/lists/*

# Creates a folder to store ssl key
RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf.template /etc/nginx/nginx.conf.template
COPY conf/gen_ssl.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/gen_ssl.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/gen_ssl.sh"]
