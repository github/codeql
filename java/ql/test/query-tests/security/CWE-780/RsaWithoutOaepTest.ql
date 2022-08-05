import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.RsaWithoutOaepQuery

class HasResult extends InlineExpectationsTest {
  HasResult() { this = "HasResult" }

  override string getARelevantTag() { result = "hasResult" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasResult" and
    value = "" and
    exists(MethodAccess ma |
      rsaWithoutOaepCall(ma) and
      location = ma.getLocation() and
      element = ma.toString()
    )
  }
}
