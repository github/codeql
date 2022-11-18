import java
import semmle.code.java.security.SensitiveKeyboardCacheQuery
import TestUtilities.InlineExpectationsTest

class SensitiveKeyboardCacheTest extends InlineExpectationsTest {
  SensitiveKeyboardCacheTest() { this = "SensitiveKeyboardCacheTest" }

  override string getARelevantTag() { result = "hasResult" }

  override predicate hasActualResult(Location loc, string element, string tag, string value) {
    exists(AndroidEditableXmlElement el |
      el = getASensitiveCachedInput() and
      loc = el.getLocation() and
      element = el.toString() and
      tag = "hasResult" and
      value = ""
    )
  }
}
