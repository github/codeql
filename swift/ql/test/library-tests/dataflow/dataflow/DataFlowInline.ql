import swift
import FlowConfig
import TestUtilities.InlineExpectationsTest

module TaintTest implements TestSig {
  string getARelevantTag() { result = "flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink, Expr sinkExpr |
      TestFlow::flow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "flow" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}

import MakeTest<TaintTest>
