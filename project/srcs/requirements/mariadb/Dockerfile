FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server mariadb-client galera-4

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/maria_config.sh /maria_config.sh

RUN chmod +x /maria_config.sh

ENTRYPOINT ["/maria_config.sh"]
