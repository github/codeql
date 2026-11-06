---
category: minorAnalysis
---
* Command injection modeling now recognizes argument arrays passed to `spawn` and `execFile` when the `shell` option is enabled, including string-valued shell paths and calls to `execFile` without a callback. The model distinguishes argument arrays, options objects, and callbacks, and accounts for local writes to the `shell` option before execution.
