---
category: minorAnalysis
---
* The `Buffer.qll` library will no longer report incorrect buffer sizes on certain malformed databases. As a result, the queries `cpp/static-buffer-overflow`, `cpp/overflow-buffer`, `cpp/badly-bounded-write`, `cpp/overrunning-write`, `cpp/overrunning-write-with-float`, and `cpp/very-likely-overrunning-write` will report fewer false positives on such databases.