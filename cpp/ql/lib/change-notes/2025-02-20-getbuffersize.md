---
category: minorAnalysis
---
* Fixed an issue where the `getBufferSize` predicate in `commons/Buffer.qll` was returning results for references inside `offsetof` expressions, which are not accesses to a buffer.
