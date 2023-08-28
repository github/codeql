---
category: minorAnalysis
---
* The `cpp/non-constant-format` query no longer considers an assignment on the right-hand side of another assignment to be a source of non-constant format strings. As a result, the query may now produce fewer results.
