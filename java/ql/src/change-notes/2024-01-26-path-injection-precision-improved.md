---
category: majorAnalysis
---
* The sinks of the queries `java/path-injection` and `java/path-injection-local` have been reworked. Path creation sinks have been converted to summaries instead, while sinks now are actual file read/write operations only. This has reduced the false positive ratio of both queries.
