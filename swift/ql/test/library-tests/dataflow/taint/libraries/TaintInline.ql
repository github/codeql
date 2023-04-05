import swift
import Taint
import TestUtilities.InlineExpectationsTest

class TaintTest extends InlineExpectationsTest {
  TaintTest() { this = "TaintTest" }

  override string getARelevantTag() { result = "tainted" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink, Expr sinkExpr |
      TestFlow::flow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "tainted" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
