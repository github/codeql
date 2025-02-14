import java
import semmle.code.java.security.ImplicitPendingIntentsQuery
import utils.test.InlineExpectationsTest

module ImplicitPendingIntentsTest implements TestSig {
  string getARelevantTag() { result = "hasImplicitPendingIntent" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasImplicitPendingIntent" and
    exists(DataFlow::Node sink | ImplicitPendingIntentStartFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<ImplicitPendingIntentsTest>
