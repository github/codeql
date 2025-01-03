import java
import utils.test.InlineExpectationsTest
import semmle.code.java.security.regexp.RegexInjectionQuery

module RegexInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasRegexInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasRegexInjection" and
    exists(RegexInjectionFlow::PathNode sink | RegexInjectionFlow::flowPath(_, sink) |
      location = sink.getNode().getLocation() and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

import MakeTest<RegexInjectionTest>
