# The Sink Said RUNNING: Is Your CDC-to-Iceberg Pipeline Making Progress?

A Kafka Connect task can report RUNNING while its commit coordinator produces no table commits. In the recorded local setup, control-consumer failures included UNKNOWN_MEMBER_ID. A group-protocol change restored commits, but the underlying cause was not isolated. The evidence is a recovery observation, not a universal prescription for every Iceberg sink.

## Current talk entry point

```sh
bash talk/lab/scripts/run-demo.sh
```

Historical September 28 local pipeline results only. Current Kubernetes API connection refused; no fresh cluster execution. Static script checks do not establish runtime compatibility. Historical root Compose design is superseded for this talk.

Start with [PRESENTATION_GUIDE.md](PRESENTATION_GUIDE.md), open `presentation.html`, and inspect [EVIDENCE.md](EVIDENCE.md) and [VERIFICATION.md](VERIFICATION.md). The obsolete root Compose implementation was removed; the maintained Kubernetes lab is under `talk/lab/`.

The executable material and documentation distinguish observed behavior from design guidance. License: Apache-2.0.
