import java
import semmle.code.java.security.CsrfUnprotectedRequestTypeQuery
import TestUtilities.InlineExpectationsTest

module CsrfUnprotectedRequestTypeTest implements TestSig {
  string getARelevantTag() { result = "hasCsrfUnprotectedRequestType" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasCsrfUnprotectedRequestType" and
    exists(CallPathNode src, CallPathNode sink, CallPathNode sinkPred |
      unprotectedStateChange(src, sink, sinkPred)
    |
      src.getLocation() = location and
      element = src.toString() and
      value = ""
    )
  }
}

import MakeTest<CsrfUnprotectedRequestTypeTest>
