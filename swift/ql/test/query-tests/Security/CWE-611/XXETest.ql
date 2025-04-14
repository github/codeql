import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.XXEQuery
import utils.test.InlineExpectationsTest

class TestRemoteSource extends RemoteFlowSource {
  TestRemoteSource() { this.asExpr().(ApplyExpr).getStaticTarget().getName().matches("source%") }

  override string getSourceType() { result = "Test source" }
}

module XxeTest implements TestSig {
  string getARelevantTag() { result = "hasXXE" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink, Expr sinkExpr |
      XxeFlow::flow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "hasXXE" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}

import MakeTest<XxeTest>
