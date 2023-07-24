```bash
export MSK_BOOTSTRAP_SERVER_WITH_PORT=

docker build \
-t naturalett/mirror-maker:v1 \
--no-cache \
--build-arg MSK_BOOTSTRAP_SERVER_WITH_PORT=$MSK_BOOTSTRAP_SERVER_WITH_PORT \
-f Dockerfile.MirrorMaker.Connectors .
```


```bash
helm upgrade \
-i mirror-maker \
--cleanup-on-fail \
--set 'version=v1' \
--namespace=default \
-f helm/values.yaml \
./helm
```