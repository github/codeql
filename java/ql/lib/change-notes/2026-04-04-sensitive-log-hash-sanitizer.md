---
category: minorAnalysis
---
* The `java/sensitive-log` query now treats method calls whose names contain "encrypt", "hash", or "digest" as sanitizers, consistent with the existing treatment in `java/cleartext-storage-in-log`. This reduces false positives when sensitive data is hashed or encrypted before logging.
