import java
import semmle.code.java.security.UnsafeAndroidAccessQuery
import utils.test.InlineExpectationsTest

module UnsafeAndroidAccessTest implements TestSig {
  string getARelevantTag() { result = "hasUnsafeAndroidAccess" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasUnsafeAndroidAccess" and
    exists(DataFlow::Node sink | FetchUntrustedResourceFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<UnsafeAndroidAccessTest>
