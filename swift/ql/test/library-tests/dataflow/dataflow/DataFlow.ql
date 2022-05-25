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
      sinkCall.getAnArgument() = sink.asExpr()
    )
  }

  override int explorationLimit() { result = 100 }
}

from DataFlow::PartialPathNode src, DataFlow::PartialPathNode sink, TestConfiguration test
where
  //test.isSource(src) and
  // test.isSink(sink) and
  //DataFlow::localFlow(src, sink)
  test.hasPartialFlow(src, sink, _)
select src, sink
