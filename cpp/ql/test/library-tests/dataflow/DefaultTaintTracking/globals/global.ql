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

class IRGlobalDefaultTaintTrackingTest extends InlineExpectationsTest {
  IRGlobalDefaultTaintTrackingTest() { this = "IRGlobalDefaultTaintTrackingTest" }

  override string getARelevantTag() { result = "ir" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Element tainted |
      tag = "ir" and
      irTaint(_, tainted, value) and
      location = tainted.getLocation() and
      element = tainted.toString()
    )
  }
}

class AstGlobalDefaultTaintTrackingTest extends InlineExpectationsTest {
  AstGlobalDefaultTaintTrackingTest() { this = "ASTGlobalDefaultTaintTrackingTest" }

  override string getARelevantTag() { result = "ast" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Element tainted |
      tag = "ast" and
      astTaint(_, tainted, value) and
      location = tainted.getLocation() and
      element = tainted.toString()
    )
  }
}
