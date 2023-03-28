import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CleartextLoggingQuery
import TestUtilities.InlineExpectationsTest

class CleartextLogging extends InlineExpectationsTest {
  CleartextLogging() { this = "CleartextLogging" }

  override string getARelevantTag() { result = "hasCleartextLogging" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      CleartextLoggingConfiguration config, DataFlow::Node source, DataFlow::Node sink,
      Expr sinkExpr
    |
      config.hasFlow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "hasCleartextLogging" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
