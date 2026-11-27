---
category: minorAnalysis
---
* Fixed false positives in the command injection queries when untrusted data is passed as positional parameters (`$0`, `$1`, ...) to `sh -c` or `bash -c` rather than as the command string itself.
