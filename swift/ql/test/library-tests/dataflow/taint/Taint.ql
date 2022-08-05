/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.DataFlow::DataFlow
import PathGraph

class TestConfiguration extends TaintTracking::Configuration {
  TestConfiguration() { this = "TestConfiguration" }

  override predicate isSource(Node src) {
    src.asExpr().(CallExpr).getStaticTarget().getName() = "source()"
  }

  override predicate isSink(Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName() = "sink(arg:)" and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }

  override int explorationLimit() { result = 100 }
}

from PathNode src, PathNode sink, TestConfiguration test
where test.hasFlowPath(src, sink)
select sink, src, sink, "result"
