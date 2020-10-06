docker build -t cmak .
docker stop cmak
docker run -ti --rm \
  -p 127.0.0.1:9000:9000 \
  -e ZK_HOSTS=zk1:2181,zk2:2181,zk3:2181 \
  -e KAFKA_MANAGER_AUTH_ENABLED=true \
  -e KAFKA_MANAGER_USERNAME=admin \
  -e KAFKA_MANAGER_PASSWORD=kafka \
  -e KINIT_PRINCIPAL=myprinc@MYREALM \
  -v /data/cmak:/app \
  --name cmak \
  cmak
