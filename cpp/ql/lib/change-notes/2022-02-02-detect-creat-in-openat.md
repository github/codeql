---
category: minorAnalysis
---
* The `cpp/world-writable-file-creation` query now only detects `openat` calls with the `O_CREAT` flag, irrespective of whether the `mode` argument is present.
