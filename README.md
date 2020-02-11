## docker-kafka-zk
docker compose for 3 node kafka and 3 node zk

- Zookeeper available @ `$DOCKER_HOST_DNS:2181,$DOCKER_HOST_DNS:2182,$DOCKER_HOST_DNS:2183`
- Kafka available @ `$DOCKER_HOST_DNS:9092,$DOCKER_HOST_DNS:9093,$DOCKER_HOST_DNS:9094`

Run with:

```
export DOCKER_HOST_DNS=127.0.0.1  # your docker machine IP `<docker-machine-ip>`

docker-compose -f docker-compose.yml up
docker-compose -f docker-compose.yml down
```

