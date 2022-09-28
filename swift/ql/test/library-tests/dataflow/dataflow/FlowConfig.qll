/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.DataFlow

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
