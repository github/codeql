import java
import semmle.code.java.security.UnsafeDeserializationQuery
import TestUtilities.InlineExpectationsTest

module UnsafeDeserializationTest implements TestSig {
  string getARelevantTag() { result = "unsafeDeserialization" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "unsafeDeserialization" and
    exists(DataFlow::Node sink | UnsafeDeserializationFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<UnsafeDeserializationTest>
