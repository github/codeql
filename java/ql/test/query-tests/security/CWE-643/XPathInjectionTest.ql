import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.security.XPathInjectionQuery
import TestUtilities.InlineExpectationsTest

class HasXPathInjectionTest extends InlineExpectationsTest {
  HasXPathInjectionTest() { this = "HasXPathInjectionTest" }

  override string getARelevantTag() { result = "hasXPathInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXPathInjection" and
    exists(DataFlow::Node sink | XPathInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
