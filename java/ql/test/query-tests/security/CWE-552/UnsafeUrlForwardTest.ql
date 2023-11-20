import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.UnsafeUrlForwardQuery

module UnsafeUrlForwardTest implements TestSig {
  string getARelevantTag() { result = "hasUnsafeUrlForward" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasUnsafeUrlForward" and
    exists(UnsafeUrlForwardFlow::PathNode sink | UnsafeUrlForwardFlow::flowPath(_, sink) |
      location = sink.getNode().getLocation() and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

import MakeTest<UnsafeUrlForwardTest>
