import java
import utils.test.InlineExpectationsTest
private import semmle.code.java.frameworks.spring.SpringController

module TestRequestController implements TestSig {
  string getARelevantTag() { result = "RequestMappingURL" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "RequestMappingURL" and
    exists(SpringRequestMappingMethod m |
      m.getLocation() = location and
      element = m.toString() and
      value = "\"" + m.getAValue() + "\""
    )
  }
}

import MakeTest<TestRequestController>
