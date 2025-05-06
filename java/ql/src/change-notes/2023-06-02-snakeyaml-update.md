---
category: minorAnalysis
---
* The query `java/unsafe-deserialization` has been updated to take the release of SnakeYaml 2.0 into account. Starting in that version, deserialization of untrusted YAML is protected against remote code execution by default. Deserializers configured with an unsafe `org.yaml.snakeyaml.inspector.TagInspector` are still vulnerable and detected by the query.
