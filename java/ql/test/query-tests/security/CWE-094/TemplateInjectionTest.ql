import java
import semmle.code.java.security.TemplateInjectionQuery
import utils.test.InlineExpectationsTest

module TemplateInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasTemplateInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTemplateInjection" and
    exists(DataFlow::Node sink | TemplateInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<TemplateInjectionTest>
