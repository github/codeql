import java
import semmle.code.java.security.ConditionalBypassQuery
import utils.test.InlineExpectationsTest

module ConditionalBypassTest implements TestSig {
  string getARelevantTag() { result = "hasConditionalBypassTest" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasConditionalBypassTest" and
    exists(DataFlow::Node sink | ConditionalBypassFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<ConditionalBypassTest>
