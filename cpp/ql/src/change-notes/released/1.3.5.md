## 1.3.5

### Minor Analysis Improvements

* Due to changes in libraries the query "Static array access may cause overflow" (`cpp/static-buffer-overflow`) will no longer report cases where multiple fields of a struct or class are written with a single `memset` or similar operation.
* The query "Call to memory access function may overflow buffer" (`cpp/overflow-buffer`) has been added to the security-extended query suite. The query detects a range of buffer overflow and underflow issues.
