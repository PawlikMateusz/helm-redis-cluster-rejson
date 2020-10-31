FROM bitnami/redis-cluster

COPY rejson.so /usr/lib/redis/modules/rejson.so

USER root
RUN sed -i '29i\ \ \ \ ARGS+=("--loadmodule" "/usr/lib/redis/modules/rejson.so")' /opt/bitnami/scripts/redis-cluster/run.sh
USER 1001
