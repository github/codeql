---
category: minorAnalysis
---
* The sensitive data heuristics treat names built on `trusted_schema`, such as SQLite's `set_trusted_schema` setting, as non-sensitive. This removes false positive results from queries that use the sensitive data library (for example `rust/cleartext-logging`).
