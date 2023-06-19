import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.security.CleartextLoggingQuery
import TestUtilities.InlineExpectationsTest

module CleartextLogging implements TestSig {
  string getARelevantTag() { result = "hasCleartextLogging" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink, Expr sinkExpr |
      CleartextLoggingFlow::flow(source, sink) and
      sinkExpr = sink.asExpr() and
      location = sinkExpr.getLocation() and
      element = sinkExpr.toString() and
      tag = "hasCleartextLogging" and
      value = source.asExpr().getLocation().getStartLine().toString()
    )
  }
}

import MakeTest<CleartextLogging>
