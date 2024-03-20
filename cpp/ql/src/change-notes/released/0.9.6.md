## 0.9.6

### Minor Analysis Improvements

* The "non-constant format string" query (`cpp/non-constant-format`) has been converted to a `path-problem` query.
* The new C/C++ dataflow and taint-tracking libraries (`semmle.code.cpp.dataflow.new.DataFlow` and `semmle.code.cpp.dataflow.new.TaintTracking`) now implicitly assume that dataflow and taint modelled via `DataFlowFunction` and `TaintFunction` always fully overwrite their buffers and thus act as flow barriers. As a result, many dataflow and taint-tracking queries now produce fewer false positives. To remove this assumption and go back to the previous behavior for a given model, one can override the new `isPartialWrite` predicate.
