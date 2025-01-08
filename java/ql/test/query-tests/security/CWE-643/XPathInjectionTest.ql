import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.XPathInjectionQuery
import utils.test.InlineExpectationsTest

module HasXPathInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasXPathInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXPathInjection" and
    exists(DataFlow::Node sink | XPathInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasXPathInjectionTest>
