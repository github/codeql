import java
import semmle.code.java.security.StaticInitializationVectorQuery
import utils.test.InlineExpectationsTest

module StaticInitializationVectorTest implements TestSig {
  string getARelevantTag() { result = "staticInitializationVector" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "staticInitializationVector" and
    exists(DataFlow::Node sink | StaticInitializationVectorFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<StaticInitializationVectorTest>
