/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow

class TestConfiguration extends DataFlow::Configuration {
  TestConfiguration() { this = "TestConfiguration" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(CallExpr).getStaticTarget().getName() = "source()"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName() = "sink(arg:)" and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }

  override int explorationLimit() { result = 100 }
}

private class TestSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    // dumb model to allow testing flow through optional chaining (`x?.signum()`)
    // namespace; type; subtypes; name; signature; ext; input; output; kind
    row = ";Int;true;signum();;;Argument[-1];ReturnValue;value"
  }
}
