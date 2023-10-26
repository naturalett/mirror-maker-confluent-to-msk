FROM --platform=linux/amd64 ubuntu:20.04

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install git curl htop man unzip vim wget jq -y && \
    git config --global --add safe.directory '*'

ARG KAFKA_VERSION=3.5.0
# ARG KAFKA_VERSION=3.3.2
ARG SCALA_VERSION=2.12
ARG BINARY_NAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}"
ARG BINARY_TAR_NAME="${BINARY_NAME}.tgz"
ARG KAFKA_URI="https://downloads.apache.org/kafka/$KAFKA_VERSION/$BINARY_TAR_NAME"
# ARG KAFKA_URI="https://archive.apache.org/dist/kafka/$KAFKA_VERSION/$BINARY_TAR_NAME"

# RUN apt-get update 
RUN apt-get install -y wget openjdk-8-jdk vim jq

RUN ["/bin/bash", "-c", "wget -nv $KAFKA_URI"]
RUN mkdir -p /opt/kafka
RUN tar xzf $BINARY_TAR_NAME -C /opt
RUN mv /opt/$BINARY_NAME/* /opt/kafka
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre

RUN curl -sSL https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.6/aws-msk-iam-auth-1.1.6-all.jar -o /opt/kafka/libs/aws-msk-iam-auth-1.1.6-all.jar
# RUN curl -sSL https://repo1.maven.org/maven2/org/apache/kafka/connect-transforms/3.5.1/connect-transforms-3.5.1.jar -o /opt/kafka/libs/connect-transforms-3.5.1.jar
RUN curl -sSL https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.19.0/jmx_prometheus_javaagent-0.19.0.jar -o /opt/kafka/libs/jmx_prometheus_javaagent-0.19.0.jar

# Following documentation: https://github.com/aws-samples/kafka-connect-mm2
ARG MAVEN_VERSION=3.5.4
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV M2_HOME /usr/share/maven
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH


RUN git clone https://github.com/aws-samples/mirrormaker2-msk-migration.git
WORKDIR mirrormaker2-msk-migration/CustomMM2ReplicationPolicy
COPY CustomMM2ReplicationPolicy.java ./CustomMM2ReplicationPolicy/src/main/java/com/amazonaws/kafka/samples/
COPY TestCustomMM2ReplicationPolicy.java ./CustomMM2ReplicationPolicy/src/test/java/com/amazonaws/kafka/samples/
RUN mvn clean install
RUN mv target/CustomMM2ReplicationPolicy-1.0-SNAPSHOT.jar /opt/kafka/libs/

EXPOSE 8083
ENTRYPOINT ["/bin/sh", "-c", "/opt/kafka/bin/connect-distributed.sh /etc/connect-mirror-maker/connect-mirror-maker.properties"]
