import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.regexp.RegexInjectionQuery

class RegexInjectionTest extends InlineExpectationsTest {
  RegexInjectionTest() { this = "RegexInjectionTest" }

  override string getARelevantTag() { result = "hasRegexInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasRegexInjection" and
    exists(RegexInjectionFlow::PathNode sink | RegexInjectionFlow::flowPath(_, sink) |
      location = sink.getNode().getLocation() and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}
