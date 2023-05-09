import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.PathInjectionQuery
import TestUtilities.InlineExpectationsTest

class PathInjectionTest extends InlineExpectationsTest {
  PathInjectionTest() { this = "PathInjectionTest" }

  override string getARelevantTag() { result = "hasPathInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink |
      PathInjectionFlow::flow(source, sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "hasPathInjection" and
      location.getFile().getName() != "" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
