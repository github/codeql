import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CleartextLoggingQuery
import utils.test.InlineExpectationsTest

module CleartextLogging implements TestSig {
  string getARelevantTag() { result = "hasCleartextLogging" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink |
      CleartextLoggingFlow::flow(source, sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "hasCleartextLogging" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}

import MakeTest<CleartextLogging>
