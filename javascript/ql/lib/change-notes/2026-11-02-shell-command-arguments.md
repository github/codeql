---
category: minorAnalysis
---
* Command injection modeling now recognizes argument arrays passed to `spawn` and `execFile` when the `shell` option is enabled, including string-valued shell paths and calls to `execFile` without a callback.
