/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.DataFlow
import DataFlow::PathGraph

class TestConfiguration extends DataFlow::Configuration {
  TestConfiguration() { this = "TestConfiguration" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(CallExpr).getStaticTarget().getName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName() = "sink" and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }

  override int explorationLimit() { result = 100 }
}

from DataFlow::PathNode src, DataFlow::PathNode sink, TestConfiguration test
where test.hasFlowPath(src, sink)
select sink, src, sink, "result"
