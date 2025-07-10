import java
import semmle.code.java.security.ImproperIntentVerificationQuery
import utils.test.InlineExpectationsTest

module HasFlowTest implements TestSig {
  string getARelevantTag() { result = "hasResult" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasResult" and
    exists(Method orm | unverifiedSystemReceiver(_, orm, _) |
      orm.getLocation() = location and
      element = orm.toString() and
      value = ""
    )
  }
}

import MakeTest<HasFlowTest>
