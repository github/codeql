import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.PathInjectionQuery
import utils.test.InlineExpectationsTest

module PathInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasPathInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<PathInjectionTest>
