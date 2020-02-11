#!/bin/bash
set -e

export file=$1
#!/bin/bash
f () {
    errcode=$?
    echo "error $errorcode"
    echo "the command executing at the time of the error was"
    echo "$BASH_COMMAND"
    echo "on line ${BASH_LINENO[0]}"
    docker-compose -f $file down
    exit $errcode
}
trap f ERR

all_great(){
    echo "Verifying Process"
    running=`docker-compose -f $1 ps | grep Up | wc -l`
    if [ "$running" != "$2" ]; then
        docker-compose -f $1 ps
        docker-compose -f $1 logs
        exit 1
    fi
}

kafka_tests(){
    echo "Testing Kafka"
    topic="testtopic"
    if grep -q kafka3 $1; then replication_factor="3"; else replication_factor="1"; fi
    for i in 1 2 3 4 5; do echo "trying to create test topic" && kafka-topics --create --topic $topic --replication-factor $replication_factor --partitions 12 --zookeeper $DOCKER_HOST_DNS:2181 && break || sleep 5; done
    for x in {1..100}; do echo $x; done | kafka-console-producer --broker-list $DOCKER_HOST_DNS:9092 --topic $topic
    rows=`kafka-console-consumer --bootstrap-server $DOCKER_HOST_DNS:9092 --topic $topic --from-beginning --timeout-ms 2000 | wc -l`
    if [ "$rows" != "100" ]; then
        kafka-console-consumer --bootstrap-server $DOCKER_HOST_DNS:9092 --topic test-topic --from-beginning --timeout-ms 2000 | wc -l
        exit 1
    else
        echo "Kafka Test Success"
    fi
}


docker-compose -f $file up -d
sleep 10

docker-compose -f $file ps

all_great $1 $2
kafka_tests $1
all_great $1 $2

docker-compose -f $file down
echo "Success!"