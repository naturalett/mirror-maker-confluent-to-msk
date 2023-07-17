```bash
export CONFLUENT_BOOTSTRAP_SERVER_WITH_PORT=
export MSK_BOOTSTRAP_SERVER_WITH_PORT=
export WHITE_LIST_TOPICS=
export CONFLUENT_KEY=
export CONFLUENT_SECRET=
export MSK_CLUSTER_NAME=

docker build \
-t naturalett/mirror-maker:97594d57 \
--no-cache \
--build-arg CONFLUENT_BOOTSTRAP_SERVER_WITH_PORT=$CONFLUENT_BOOTSTRAP_SERVER_WITH_PORT \
--build-arg MSK_BOOTSTRAP_SERVER_WITH_PORT=$MSK_BOOTSTRAP_SERVER_WITH_PORT \
--build-arg WHITE_LIST_TOPICS=$WHITE_LIST_TOPICS \
--build-arg CONFLUENT_KEY=$CONFLUENT_KEY \
--build-arg CONFLUENT_SECRET=$CONFLUENT_SECRET \
--build-arg MSK_CLUSTER_NAME=$MSK_CLUSTER_NAME \
-f Dockerfile.MirrorMaker .
```


```bash
helm upgrade \
-i mirror-maker \
--cleanup-on-fail \
--set 'version=97594d57' \
--namespace=default \
-f helm/values.yaml \
./helm
```