import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.UrlForwardQuery

module UrlForwardTest implements TestSig {
  string getARelevantTag() { result = "hasUrlForward" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasUrlForward" and
    exists(UrlForwardFlow::PathNode sink | UrlForwardFlow::flowPath(_, sink) |
      location = sink.getNode().getLocation() and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

import MakeTest<UrlForwardTest>
