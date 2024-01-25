## 0.10.0

### Minor Analysis Improvements

* Functions that do not return due to calling functions that don't return (e.g. `exit`) are now detected as
 non-returning in the IR and dataflow.
* Treat functions that reach the end of the function as returning in the IR.
  They used to be treated as unreachable but it is allowed in C. 
* The `DataFlow::asDefiningArgument` predicate now takes its argument from the range starting at `1` instead of `2`. Queries that depend on the single-parameter version of `DataFlow::asDefiningArgument` should have their arguments updated accordingly.
