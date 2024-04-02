---
category: minorAnalysis
---
* Data flow queries that track flow from *local* flow sources now use the current *threat model* configuration instead. This may lead to changes in the produced alerts if the threat model configuration only uses *remote* flow sources. The changed queries are `cs/code-injection`, `cs/resource-injection`, `cs/sql-injection`, and `cs/uncontrolled-format-string`.

