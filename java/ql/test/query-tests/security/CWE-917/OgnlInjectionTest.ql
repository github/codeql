import java
import semmle.code.java.security.OgnlInjectionQuery
import utils.test.InlineExpectationsTest

module OgnlInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasOgnlInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasOgnlInjection" and
    exists(DataFlow::Node sink | OgnlInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<OgnlInjectionTest>
