import java
import semmle.code.java.security.ImproperIntentVerificationQuery
import TestUtilities.InlineExpectationsTest

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "hasResult" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasResult" and
    exists(Method orm | unverifiedSystemReceiver(_, orm, _) |
      orm.getLocation() = location and
      element = orm.toString() and
      value = ""
    )
  }
}
