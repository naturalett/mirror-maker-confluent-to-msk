# Mirror Maker


[Here, you'll find details regarding the properties of the initial mirror-maker](https://github.com/Natural-Intelligence/mirror-maker/blob/main/helm/templates/configmap.yaml)

### How does the push_configs.py work?
The structure that we see in the current folder is:
* staging
  * xsitestg-ue2 -> **It presents the destination cluster**
    * cfnprod -> **the source cluster**
    * ops-ue1 -> **the source cluster**
    * xsitebos-ue1 -> **the source cluster**
* production
  * xsiterts-aps1 -> **It presents the destination cluster**
    * xsitebos-ue1 -> **the source cluster**
---

##### Topic : [`offset.storage.topic=connect-offsets`](https://github.com/apache/kafka/blob/3.5.1/config/connect-distributed.properties#L43)
Topic to use for storing offsets. This topic should have many partitions and be replicated and compacted.\
- *Expected action from the user:* Set a unique name


**Important factor to notice: [`offset.storage.replication.factor`](https://github.com/apache/kafka/blob/3.5.1/config/connect-distributed.properties#L44C1-L44C36)** \
The replication factor used when Connect creates the topic used to store connector offsets. This should always be at least 3 for a production system.\
- *Expected action from the user:* Set the replication factor to `3`

---

#### Topic : [`config.storage.topic=connect-configs`](https://github.com/apache/kafka/blob/3.5.1/config/connect-distributed.properties#L53)
The name of the topic where connector and task configuration data are stored. This must be the same for all Workers with the same [group.id](https://github.com/apache/kafka/blob/3.5.1/config/connect-distributed.properties#L26).
- *Expected action from the user:* Set a unique name


**Important factor to notice: [`group.id`](https://github.com/apache/kafka/blob/3.5.1/config/connect-distributed.properties#L26)** \
A unique string that identifies the Connect cluster group this Worker belongs to.
- *Expected action from the user:* Set a unique name

---
#### Topic : [`status.storage.topic=connect-status`](https://github.com/apache/kafka/blob/3.5.1/config/connect-distributed.properties#L62)
Topic to use for storing statuses. This topic can have multiple partitions and should be replicated and compacted. This must be the same for all Workers with the same group.id.
- *Expected action from the user:* Set a unique name