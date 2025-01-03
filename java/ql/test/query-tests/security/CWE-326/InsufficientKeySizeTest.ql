import java
import utils.test.InlineExpectationsTest
import semmle.code.java.security.InsufficientKeySizeQuery

module InsufficientKeySizeTest implements TestSig {
  string getARelevantTag() { result = "hasInsufficientKeySize" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsufficientKeySize" and
    exists(KeySizeFlow::PathNode sink | KeySizeFlow::flowPath(_, sink) |
      sink.getNode().getLocation() = location and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

import MakeTest<InsufficientKeySizeTest>
