---
category: minorAnalysis
---
* Increase query precision for `cs/useless-gethashcode-call` by not flagging calls to `GetHashCode` on `uint`, `long` and `ulong`.
