---
category: deprecated
---
* Custom data flow queries will need to be migrated in order to use the shared data flow library. Until migrated, such queries will compile with deprecation warnings and run with a
  deprecated copy of the old data flow library. The deprecation layer will be removed in early 2026, after which any unmigrated queries will stop working.
  See more information in the [migration guide](https://codeql.github.com/docs/codeql-language-guides/migrating-javascript-dataflow-queries).
