import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.PathInjectionQuery
import TestUtilities.InlineExpectationsTest

class PathInjectionTest extends InlineExpectationsTest {
  PathInjectionTest() { this = "PathInjectionTest" }

  override string getARelevantTag() { result = "hasPathInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(
      PathInjectionConfiguration config, DataFlow::Node source, DataFlow::Node sink, Expr sinkExpr
    |
      config.hasFlow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "hasPathInjection" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
