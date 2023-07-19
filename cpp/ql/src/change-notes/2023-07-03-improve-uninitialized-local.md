---
category: minorAnalysis
---
* The `cpp/uninitialized-local` query now excludes uninitialized uses that are explicitly cast to void and are expression statements. As a result, the query will report less false positives.