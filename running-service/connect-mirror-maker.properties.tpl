# Licensed to the Apache Software Foundation (ASF) under A or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# see org.apache.kafka.clients.consumer.ConsumerConfig for more details

# Sample MirrorMaker 2.0 top-level configuration file3
# Run with ./bin/connect-mirror-maker.sh connect-mirror-maker.properties 

# specify any number of cluster aliases
clusters=clusterA, clusterB

# connection information for each cluster
# This is a comma separated host:port pairs for each cluster
# for e.g. "A_host1:9092, A_host2:9092, A_host3:9092"
clusterA.bootstrap.servers = MSK_BOOTSTRAP_SERVER_WITH_PORT
clusterB.bootstrap.servers = CONFLUENT_BOOTSTRAP_SERVER_WITH_PORT


############################# Confluent Extra Configuration  #############################
clusterB.ssl.endpoint.identification.algorithm=https
clusterB.security.protocol=SASL_SSL
clusterB.sasl.mechanism=PLAIN
clusterB.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="CONFLUENT_KEY" password="CONFLUENT_SECRET";


############################# MSK Extra Configuration  #############################
clusterA.ssl.endpoint.identification.algorithm=https
clusterA.sasl.mechanism=AWS_MSK_IAM
clusterA.security.protocol=SASL_SSL
clusterA.producer.override.sasl.mechanism=AWS_MSK_IAM
clusterA.producer.override.security.protocol=SASL_SSL
clusterA.producer.override.sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required;
clusterA.producer.override.ssl.endpoint.identification.algorithm=https
clusterA.producer.override.equest.timeout.ms=20000
clusterA.producer.override.retry.backoff.ms=500
clusterA.producer.override.sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
clusterA.producer.sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
clusterA.sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
clusterA.client.sasl.client.callback.handler.class=software.amazon.msk.auth.iam.IAMClientCallbackHandler
clusterA.producer.override.sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="MSK_CLUSTER_NAME";
clusterA.sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="MSK_CLUSTER_NAME";
clusterA.producer.sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="MSK_CLUSTER_NAME";
clusterA.consumer.sasl.jaas.config=software.amazon.msk.auth.iam.IAMLoginModule required awsProfileName="MSK_CLUSTER_NAME";


############################# Topic Configuration  #############################
# enable and configure individual replication flows
clusterA->clusterB.enabled = true

# regex which defines which topics gets replicated. For eg "foo-.*"
clusterA->clusterB.topics = WHITE_LIST_TOPICS

clusterB->clusterA.enabled = true
clusterB->clusterA.topics = WHITE_LIST_TOPICS

replication.policy.class=org.apache.kafka.connect.mirror.IdentityReplicationPolicy
replication.policy.separator=
source.cluster.alias=clusterB
target.cluster.alias=

#######################################################################################

# Setting replication factor of newly created remote topics
replication.factor=3

############################# Internal Topic Settings  #############################
# The replication factor for mm2 internal topics "heartbeats", "B.checkpoints.internal" and
# "mm2-offset-syncs.B.internal"
# For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
checkpoints.topic.replication.factor=3
heartbeats.topic.replication.factor=3
offset-syncs.topic.replication.factor=3

# The replication factor for connect internal topics "mm2-configs.B.internal", "mm2-offsets.B.internal" and
# "mm2-status.B.internal"
# For anything other than development testing, a value greater than 1 is recommended to ensure availability such as 3.
offset.storage.replication.factor=3
status.storage.replication.factor=3
config.storage.replication.factor=3

# customize as needed
# replication.policy.separator = _
# sync.topic.acls.enabled = false
# emit.heartbeats.interval.seconds = 5