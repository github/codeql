import java
import experimental.semmle.code.java.security.DecompressionBombQuery
import TestUtilities.InlineExpectationsTest

module BombTest implements TestSig {
  string getARelevantTag() { result = "bomb" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "bomb" and
    exists(DataFlow::Node sink | DecompressionBombsFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<BombTest>
