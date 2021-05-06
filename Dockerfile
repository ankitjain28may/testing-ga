FROM bitnami/mysql:8.0
LABEL maintainer "Bitnami <containers@bitnami.com>"

COPY ./mysql/my_custom.cnf /opt/bitnami/mysql/conf/my_custom.cnf
