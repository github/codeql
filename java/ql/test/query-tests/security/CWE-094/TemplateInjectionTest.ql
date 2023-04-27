import java
import semmle.code.java.security.TemplateInjectionQuery
import TestUtilities.InlineExpectationsTest

class TemplateInjectionTest extends InlineExpectationsTest {
  TemplateInjectionTest() { this = "TemplateInjectionTest" }

  override string getARelevantTag() { result = "hasTemplateInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTemplateInjection" and
    exists(DataFlow::Node sink | TemplateInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
