# ADR-001: Schema Registry as the Contract Layer

## Status

Accepted

## Context

In a CDC-to-lakehouse pipeline, data flows from a relational database through Kafka to Iceberg tables. Schema changes at the source (e.g., `ALTER TABLE ADD COLUMN`) must propagate correctly through every stage without breaking consumers.

Options considered:

1. **No schema management** — Use JSON without a schema registry. Schema changes break consumers silently.
2. **Schema-on-read** — Store raw events, infer schema at query time. Fragile and slow for large datasets.
3. **Schema registry as contract layer** — Enforce Avro schemas at the Kafka boundary, with compatibility rules preventing breaking changes.

## Decision

Use **Apicurio Registry** as the schema contract layer between Debezium (producer) and the Iceberg sink (consumer).

- Debezium auto-registers Avro schemas when it detects source schema changes
- The Iceberg sink connector deserializes events using schemas from the registry
- Compatibility rules (BACKWARD by default) prevent breaking changes from reaching consumers
- The same registry that governs OpenAPI and AsyncAPI specs also governs data pipeline schemas

## Consequences

- Schema evolution is automatic: a column added in PostgreSQL appears in Iceberg without manual DDL
- Breaking changes (e.g., removing a required field) are caught at the registry boundary, not at query time
- The registry becomes a critical dependency — if it's down, the pipeline cannot serialize/deserialize events
- All schema versions are retained, enabling auditing of how the data model evolved over time
