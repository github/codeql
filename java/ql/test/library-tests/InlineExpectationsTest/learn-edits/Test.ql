import java
import utils.test.InlineExpectationsTest

module DirectTest implements TestSig {
  string getARelevantTag() { result = "java-direct" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Method method |
      method.getName() = "target" and
      method.fromSource() and
      location = method.getLocation() and
      element = method.toString() and
      tag = "java-direct" and
      value = ""
    )
  }
}

import MakeTest<DirectTest>
