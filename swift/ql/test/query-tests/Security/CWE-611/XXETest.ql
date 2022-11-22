import swift
import codeql.swift.security.XXEQuery
import TestUtilities.InlineExpectationsTest

class XxeTest extends InlineExpectationsTest {
  XxeTest() { this = "XxeTest" }

  override string getARelevantTag() { result = "hasXXE" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(XxeConfiguration config, DataFlow::Node source, DataFlow::Node sink, Expr sinkExpr |
      config.hasFlow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "hasXXE" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
