FROM debezium/connect:2.7

# Download the Iceberg sink connector
ARG ICEBERG_CONNECTOR_VERSION=0.7.0
RUN cd /kafka/connect && \
    mkdir -p iceberg-sink && \
    curl -sL "https://github.com/tabular-io/iceberg-kafka-connect/releases/download/v${ICEBERG_CONNECTOR_VERSION}/iceberg-kafka-connect-runtime-${ICEBERG_CONNECTOR_VERSION}.zip" \
      -o /tmp/iceberg-sink.zip && \
    unzip /tmp/iceberg-sink.zip -d iceberg-sink && \
    rm /tmp/iceberg-sink.zip

# Download the Apicurio Registry Avro converter
ARG APICURIO_VERSION=2.6.6.Final
RUN cd /kafka/connect && \
    mkdir -p apicurio-avro && \
    curl -sL "https://repo1.maven.org/maven2/io/apicurio/apicurio-registry-distro-connect-converter/${APICURIO_VERSION}/apicurio-registry-distro-connect-converter-${APICURIO_VERSION}.tar.gz" \
      | tar xz -C apicurio-avro
