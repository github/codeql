/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

module TestConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asExpr().(CallExpr).getStaticTarget().getName().matches("source%()")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName() = ["sink(arg:)", "sink(opt:)", "sink(str:)"] and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }
}

private class TestSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    // model to allow data flow through `signum()` as though it were an identity function, for the benefit of testing flow through optional chaining (`x?.`).
    row = ";Int;true;signum();;;Argument[-1];ReturnValue;value"
  }
}

module TestFlow = DataFlow::Global<TestConfiguration>;
