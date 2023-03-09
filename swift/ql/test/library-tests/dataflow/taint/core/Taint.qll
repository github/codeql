import swift
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.DataFlow::DataFlow

class TestConfiguration extends TaintTracking::Configuration {
  TestConfiguration() { this = "TestConfiguration" }

  override predicate isSource(Node src) {
    src.asExpr().(CallExpr).getStaticTarget().getName().matches("source%")
  }

  override predicate isSink(Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName().matches("sink%") and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }

  override int explorationLimit() { result = 100 }
}
