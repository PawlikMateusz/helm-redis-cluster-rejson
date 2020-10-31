# Redis Cluster with ReJSON

Tutorial on how to deploy redis cluster with ReJSON module using Bitnami Redis Cluster  [Helm Chart](https://github.com/bitnami/charts/tree/master/bitnami/redis-cluster)

## Create custom redis-cluster docker image

1. Copy rejson.so module from redislabs/rejson docker image

```bash
# run docker image
docker run --name rejson -d redislabs/rejson
# copy compiled rejson.so
docker cp rejson:/usr/lib/redis/modules/rejson.so ./rejson.so 
# stop docker image
docker stop rejson
```

2. Build redis-cluster docker image

WARNING: check bitnami/redis-cluster docker image if line 29 is still correct to input --loadmodule argument, if not change line number

```bash
docker build -t <PRIVATE_REGISTRY>/redis-cluster .
```

3. Push created docker image to private docker registry

```
docker push <PRIVATE_REGISTRY>/redis-cluster
```

## Deploy Bitnami Redis Cluster Helm Chart

1. Add Bitnami Redis Cluster to yours dependencies

Chart.yaml
```yaml
dependencies:
  - name: redis-cluster
    version: "3.2.10"
    repository: https://charts.bitnami.com/bitnami
```

2. Build Helm dependency 

```bash
helm dependency build <your chart>
```

3. Update values.yaml

```yaml
## Configuration values for the redis-cluster dependency.
redis-cluster:
  image:
    registry: <PRIVATE_REGISTRY>
    repository: redis-cluster
    tag: latest
    pullSecrets: ["regcred"] # yours secret to private docker registry
    pullPolicy: Always
```

__Now you should have working redis cluster with ReJSON module loaded__

## LICENSE 

This code modifies bitnami-docker-redis-cluster which is licensed under the Apache 2.0 License, and can be obtained [here](https://github.com/bitnami/bitnami-docker-redis-cluster) .