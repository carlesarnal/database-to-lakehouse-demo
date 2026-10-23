# Evidence and claim boundaries

Historical September 28 local pipeline results only. Current Kubernetes API connection refused; no fresh cluster execution. Static script checks do not establish runtime compatibility. Historical root Compose design is superseded for this talk.

## Start with a query, not a health endpoint

A Kafka Connect task can report RUNNING while its commit coordinator produces no table commits. In the recorded local setup, control-consumer failures included UNKNOWN_MEMBER_ID. A group-protocol change restored commits, but the underlying cause was not isolated. The evidence is a recovery observation, not a universal prescription for every Iceberg sink.

## Use a progress ledger

Follow one source key through its emitted Kafka event, the relevant topic/partition offset, sink progress, committed Iceberg snapshot and Trino result. These identifiers let an operator say where evidence stops. A global maximum offset is not meaningful across unrelated partitions. The companion ledger leaves observation fields blank until a run supplies them.

## Measure visibility at the consumer boundary

Two earlier local runs made an inserted row queryable after 33 and 42 seconds with a configured 10-second commit interval. Polling and query overhead are included. Those figures neither establish a production freshness SLO nor identify which stage accounts for the remainder. A configuration value should not be presented as an end-to-end measurement.

## Registry is the schema service, not the table catalog

The current Kubernetes example uses Apicurio Registry for Avro schemas and a separate Iceberg REST catalog. The table is an append-only change log: an update adds an event rather than automatically replacing a row. Reconstructing current state needs the appropriate key/order/delete logic. The old repository overview conflated these responsibilities; the talk entry point now labels that design historical.
