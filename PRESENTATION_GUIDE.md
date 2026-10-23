# Presentation guide

The Sink Said RUNNING: Is Your CDC-to-Iceberg Pipeline Making Progress?

## Audience and central claim

A Kafka Connect task can report RUNNING while its commit coordinator produces no table commits. In the recorded local setup, control-consumer failures included UNKNOWN_MEMBER_ID. A group-protocol change restored commits, but the underlying cause was not isolated. The evidence is a recovery observation, not a universal prescription for every Iceberg sink.

## 30-minute run of show

### 0:00 — A RUNNING task with zero commits

Say: A Kafka Connect task can report RUNNING while its commit coordinator produces no table commits. In the recorded local setup, control-consumer failures included UNKNOWN_MEMBER_ID. A group-protocol change restored commits, but the underlying cause was not isolated. The evidence is a recovery observation, not a universal prescription for every Iceberg sink.

Show the corresponding diagram, source record or actual command output. Pause to identify the observation that supports the claim.

### 4:00 — Capture and consume are different boundaries

Say: Follow one source key through its emitted Kafka event, the relevant topic/partition offset, sink progress, committed Iceberg snapshot and Trino result. These identifiers let an operator say where evidence stops. A global maximum offset is not meaningful across unrelated partitions. The companion ledger leaves observation fields blank until a run supplies them.

Show the corresponding diagram, source record or actual command output. Pause to identify the observation that supports the claim.

### 9:00 — A snapshot makes data queryable

Say: Two earlier local runs made an inserted row queryable after 33 and 42 seconds with a configured 10-second commit interval. Polling and query overhead are included. Those figures neither establish a production freshness SLO nor identify which stage accounts for the remainder. A configuration value should not be presented as an end-to-end measurement.

Show the corresponding diagram, source record or actual command output. Pause to identify the observation that supports the claim.

### 15:00 — Commit interval is not freshness

Say: The current Kubernetes example uses Apicurio Registry for Avro schemas and a separate Iceberg REST catalog. The table is an append-only change log: an update adds an event rather than automatically replacing a row. Reconstructing current state needs the appropriate key/order/delete logic. The old repository overview conflated these responsibilities; the talk entry point now labels that design historical.

Show the corresponding diagram, source record or actual command output. Pause to identify the observation that supports the claim.

### 21:00 — A changelog needs a current-state query

Say: Use the evidence boundary to choose the next action.

Show the corresponding diagram, source record or actual command output. Pause to identify the observation that supports the claim.

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
