---
category: minorAnalysis
---
* The `cpp/world-writable-file-creation` query now only detects `open` and `openat` calls with the `O_CREAT` or `O_TMPFILE` flag.