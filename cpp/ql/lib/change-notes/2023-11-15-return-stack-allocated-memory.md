---
category: minorAnalysis
---
* The "Returning stack-allocated memory" (`cpp/return-stack-allocated-memory`) query now also detects returning stack-allocated memory allocated by calls to `alloca`, `strdupa`, and `strndupa`.