---
category: minorAnalysis
---
* The query `go/unhandled-writable-file-close` ("Writable file handle closed without error handling") now produces fewer false positives. A deferred call to `Close` that is preceded on every execution path by a handled call to `Sync` on the same file handle is no longer flagged.
