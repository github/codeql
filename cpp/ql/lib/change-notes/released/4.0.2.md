## 4.0.2

### Minor Analysis Improvements

* Modified the `getBufferSize` predicate in `commons/Buffer.qll` to be more tolerant in some cases involving member variables in a larger struct or class.
* Fixed an issue where the `getBufferSize` predicate in `commons/Buffer.qll` was returning results for references inside `offsetof` expressions, which are not accesses to a buffer.
