import java
import semmle.code.java.security.JndiInjectionQuery
import utils.test.InlineExpectationsTest

module HasJndiInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasJndiInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasJndiInjection" and
    exists(DataFlow::Node sink | JndiInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasJndiInjectionTest>
