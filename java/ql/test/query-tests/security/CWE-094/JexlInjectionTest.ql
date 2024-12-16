import java
import semmle.code.java.security.JexlInjectionQuery
import utils.test.InlineExpectationsTest

module JexlInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasJexlInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasJexlInjection" and
    exists(DataFlow::Node sink | JexlInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<JexlInjectionTest>
