import java
import utils.test.InlineExpectationsTest
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.SensitiveUiQuery

module SensitiveTextTest implements TestSig {
  string getARelevantTag() { result = "sensitive-text" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sensitive-text" and
    exists(DataFlow::Node sink | TextFieldTracking::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<SensitiveTextTest>
