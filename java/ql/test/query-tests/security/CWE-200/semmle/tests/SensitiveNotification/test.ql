import java
import utils.test.InlineExpectationsTest
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.SensitiveUiQuery

module SensitiveNotifTest implements TestSig {
  string getARelevantTag() { result = "sensitive-notification" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sensitive-notification" and
    exists(DataFlow::Node sink | NotificationTracking::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<SensitiveNotifTest>
