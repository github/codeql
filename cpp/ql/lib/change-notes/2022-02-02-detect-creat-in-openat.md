---
category: minorAnalysis
---
* The `cpp/world-writable-file-creation` query now only detects `open` and `openat` calls with both the `O_CREAT` and `O_TMPFILE` flag, irrespective of whether the `mode` argument is present.
