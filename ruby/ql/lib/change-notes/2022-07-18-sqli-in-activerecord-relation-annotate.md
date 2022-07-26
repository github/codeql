---
category: minorAnalysis
---

- Calls to `ActiveRecord::Relation#annotate` are now recognized as`SqlExecution`s so that it will be considered as a sink for queries like rb/sql-injection.