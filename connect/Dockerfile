FROM quay.io/debezium/connect:3.5.2.Final

# Download the Iceberg sink connector
ARG ICEBERG_CONNECTOR_VERSION=0.6.19
USER root
RUN microdnf install -y unzip && microdnf clean all
USER 1001
RUN cd /kafka/connect && \
    mkdir -p iceberg-sink && \
    curl -sL "https://github.com/tabular-io/iceberg-kafka-connect/releases/download/v${ICEBERG_CONNECTOR_VERSION}/iceberg-kafka-connect-runtime-${ICEBERG_CONNECTOR_VERSION}.zip" \
      -o /tmp/iceberg-sink.zip && \
    unzip /tmp/iceberg-sink.zip -d iceberg-sink && \
    rm /tmp/iceberg-sink.zip

# Add missing Hadoop transitive dependency for local filesystem
RUN curl -sL "https://repo1.maven.org/maven2/org/apache/commons/commons-configuration2/2.10.1/commons-configuration2-2.10.1.jar" \
      -o /kafka/connect/iceberg-sink/iceberg-kafka-connect-runtime-0.6.19/lib/commons-configuration2-2.10.1.jar

# Download the Apicurio Registry Avro converter
ARG APICURIO_VERSION=3.3.0
RUN cd /kafka/connect && \
    mkdir -p apicurio-avro && \
    curl -sL "https://repo1.maven.org/maven2/io/apicurio/apicurio-registry-distro-connect-converter/${APICURIO_VERSION}/apicurio-registry-distro-connect-converter-${APICURIO_VERSION}.tar.gz" \
      | tar xz -C apicurio-avro
