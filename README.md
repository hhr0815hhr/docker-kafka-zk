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

## persistent data storage with external disk/volume.
- attach an ebs volume with instance and follow the below given steps to store data and logs safely in an external volume.

### Create LVM partitioning to enable docker to use overlay2 as Storage Driver
```
sudo rm -rf /var/lib/docker/*
sudo yum install lvm* -y
sudo pvcreate /dev/xvdb
sudo vgcreate docker /dev/xvdb
sudo lvcreate -n dockerdata -l 100%FREE docker
sudo mkfs -t xfs -n ftype=1 /dev/docker/dockerdata
sudo mount /dev/docker/dockerdata /var/lib/docker
echo "/dev/mapper/docker-dockerdata   /var/lib/docker xfs     defaults        0 0" | sudo tee -a /etc/fstab

# Reset Storage Driver and reload Docker
echo '{"storage-driver": "overlay2"} ' | sudo tee /etc/docker/daemon.json
sudo systemctl daemon-reload
sudo systemctl start docker
```