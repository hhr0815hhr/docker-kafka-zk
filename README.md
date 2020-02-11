## docker-kafka-zk
docker compose for 3 node kafka and 3 node zk

- Zookeeper will be available at `$DOCKER_HOST_IP:2181,$DOCKER_HOST_IP:2182,$DOCKER_HOST_IP:2183`
- Kafka will be available at `$DOCKER_HOST_IP:9092,$DOCKER_HOST_IP:9093,$DOCKER_HOST_IP:9094`

Run with:

```
export DOCKER_HOST_IP=127.0.0.1  # your docker machine IP `<docker-machine-ip>`

docker-compose -f docker-compose.yml up
docker-compose -f docker-compose.yml down
```

