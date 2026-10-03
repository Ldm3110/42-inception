FROM debian:trixie-backports

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server mariadb-client galera-4

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY test.sh /test.sh
COPY .env /.env

RUN chmod +x /test.sh
ENTRYPOINT ["/test.sh"]
