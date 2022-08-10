/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.DataFlow::DataFlow
import TestUtilities.InlineExpectationsTest

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

class TaintTest extends InlineExpectationsTest {
  TaintTest() { this = "taintedFromLine" }

  override string getARelevantTag() { result = "taintedFromLine" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TestConfiguration config, Node source, Node sink, Expr sinkExpr |
      config.hasFlow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "taintedFromLine" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
