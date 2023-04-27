import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.PredicateInjectionQuery
import TestUtilities.InlineExpectationsTest

class PredicateInjectionTest extends InlineExpectationsTest {
  PredicateInjectionTest() { this = "PredicateInjectionTest" }

  override string getARelevantTag() { result = "hasPredicateInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink, Expr sinkExpr |
      PredicateInjectionFlow::flow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "hasPredicateInjection" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}
