# ADR-001: Apicurio Registry as Schema Registry and Iceberg Catalog

## Status

Accepted

## Context

In a CDC-to-lakehouse pipeline, data flows from a relational database through Kafka to Iceberg tables. Schema changes at the source (e.g., `ALTER TABLE ADD COLUMN`) must propagate correctly through every stage without breaking consumers.

Beyond schema governance, the pipeline also needs an Iceberg catalog to manage table metadata (snapshots, partitions, schema versions). A separate catalog service adds operational complexity.

Options considered:

1. **No schema management** — Use JSON without a schema registry. Schema changes break consumers silently.
2. **Schema-on-read** — Store raw events, infer schema at query time. Fragile and slow for large datasets.
3. **Schema registry + separate Iceberg catalog** — Two components: one for schema governance, one for table metadata.
4. **Apicurio Registry as both** — Single component serving as schema registry AND Iceberg REST catalog.

## Decision

Use **Apicurio Registry** as both the schema contract layer AND the Iceberg REST catalog, eliminating the need for a separate catalog service.

- Debezium auto-registers Avro schemas when it detects source schema changes
- The Iceberg sink connector deserializes events using schemas from the registry
- Apicurio Registry's Iceberg REST Catalog API (`/apis/iceberg/v1`) manages table metadata, snapshots, and schema evolution
- Trino and the Iceberg sink both connect to Apicurio Registry for catalog operations
- Compatibility rules (BACKWARD by default) prevent breaking changes from reaching consumers
- The same registry that governs OpenAPI and AsyncAPI specs also governs data pipeline schemas and lakehouse table metadata

## Consequences

- Schema evolution is automatic: a column added in PostgreSQL appears in Iceberg without manual DDL
- Breaking changes (e.g., removing a required field) are caught at the registry boundary, not at query time
- One fewer service to deploy and operate — Apicurio Registry handles both schema governance and Iceberg catalog
- The registry becomes a critical dependency — if it's down, the pipeline cannot serialize/deserialize events or manage table metadata
- All schema versions and table metadata are retained, enabling auditing of how the data model evolved over time
- Demonstrates the breadth of Apicurio Registry beyond traditional schema registry use cases
