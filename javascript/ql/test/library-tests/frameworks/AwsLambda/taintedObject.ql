import javascript
import semmle.javascript.security.TaintedObject
import utils.test.InlineExpectationsTest

module TestConfig implements TestSig {
  string getARelevantTag() { result = "taintedObjectSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TaintedObject::Source src |
      location = src.getLocation() and
      element = src.toString() and
      tag = "taintedObjectSource" and
      value = ""
    )
  }
}

import MakeTest<TestConfig>
