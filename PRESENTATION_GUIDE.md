# Presentation guide

The Sink Said RUNNING: Is Your CDC-to-Iceberg Pipeline Making Progress?

## Audience and central claim

A Kafka Connect task can report RUNNING while its commit coordinator produces no table commits. In the recorded local setup, control-consumer failures included UNKNOWN_MEMBER_ID. A group-protocol change restored commits, but the underlying cause was not isolated. The evidence is a recovery observation, not a universal prescription for every Iceberg sink.

## 30-minute run of show

### 0:00 — A RUNNING task with zero commits

A Kafka Connect task can report RUNNING while its commit coordinator produces no table commits. In the recorded local setup, control-consumer failures included UNKNOWN_MEMBER_ID. A group-protocol change restored commits, but the underlying cause was not isolated. The evidence is a recovery observation, not a universal prescription for every Iceberg sink.

Show the control-consumer error and the zero-table commit message from the recorded investigation.

### 4:00 — Capture and consume are different boundaries

Follow one source key through its emitted Kafka event, the relevant topic/partition offset, sink progress, committed Iceberg snapshot and Trino result. These identifiers let an operator say where evidence stops. A global maximum offset is not meaningful across unrelated partitions. The companion ledger leaves observation fields blank until a run supplies them.

Follow one key using progress-ledger.txt, keeping each partition offset in its own context.

### 9:00 — Commit interval versus measured freshness

Two earlier local runs made an inserted row queryable after 33 and 42 seconds with a configured 10-second commit interval. Polling and query overhead are included. Those figures neither establish a production freshness SLO nor identify which stage accounts for the remainder. A configuration value should not be presented as an end-to-end measurement.

Compare the two local freshness observations with the configured commit interval.

### 15:00 — Query current state from the changelog

The current Kubernetes example uses Apicurio Registry for Avro schemas and a separate Iceberg REST catalog. The table is an append-only change log: an update adds an event rather than automatically replacing a row. Reconstructing current state needs the appropriate key/order/delete logic.

Show the append-only change events and the latest-state query in talk/lab/README.md.

### 21:00 — Locate the last proven stage of progress

Summarize the decision the example supports and the assumptions behind it.

Ask which boundary has the last evidence of progress before the missing query result.

### 26:00 — Questions and buffer

Ask what the demonstration establishes and what it leaves open. Do not add another feature if time is short.

## Setup and fallback

```sh
bash talk/lab/scripts/run-demo.sh
```

Historical September 28 local pipeline results only. Current Kubernetes API connection refused; no fresh cluster execution. Static script checks do not establish runtime compatibility. Historical root Compose design is superseded for this talk.

Prebuild/download dependencies. Keep a recording of an actual successful run; if unavailable, use the documented walkthrough and say it is not live execution. Never substitute fabricated success output.

## Questions to prepare

- What is the simplest alternative?
- Which failure was actually exercised?
- Which guarantee belongs to the application rather than the infrastructure?
- Which result changes with versions or workload?

## 25-minute adaptation

Use one central trace, shorten setup and reserve three minutes for questions. Move the secondary implementation example to backup.
