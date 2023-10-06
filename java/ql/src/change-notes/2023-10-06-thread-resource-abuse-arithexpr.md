---
category: majorAnalysis
---
* The `java/thread-resource-abuse` experimental query has been improved to ensure that tained values flowing through arithmetic operations are preserved. For example, `Thread.sleep(untrustedInput * 1000)` will now be detected as a vulnerability.
 