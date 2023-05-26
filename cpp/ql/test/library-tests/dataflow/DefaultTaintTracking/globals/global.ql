import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTrackingImpl as AstTaintTracking
import semmle.code.cpp.ir.dataflow.DefaultTaintTracking as IRDefaultTaintTracking
import TestUtilities.InlineExpectationsTest

predicate astTaint(Expr source, Element sink, string globalVar) {
  AstTaintTracking::taintedIncludingGlobalVars(source, sink, globalVar) and globalVar != ""
}

predicate irTaint(Expr source, Element sink, string globalVar) {
  IRDefaultTaintTracking::taintedIncludingGlobalVars(source, sink, globalVar) and globalVar != ""
}

module IRGlobalDefaultTaintTrackingTest implements TestSig {
  string getARelevantTag() { result = "ir" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Element tainted |
      tag = "ir" and
      irTaint(_, tainted, value) and
      location = tainted.getLocation() and
      element = tainted.toString()
    )
  }
}

module AstGlobalDefaultTaintTrackingTest implements TestSig {
  string getARelevantTag() { result = "ast" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Element tainted |
      tag = "ast" and
      astTaint(_, tainted, value) and
      location = tainted.getLocation() and
      element = tainted.toString()
    )
  }
}

import MakeTest<MergeTests<IRGlobalDefaultTaintTrackingTest, AstGlobalDefaultTaintTrackingTest>>
