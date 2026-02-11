import java
import semmle.code.java.security.SensitiveKeyboardCacheQuery
import utils.test.InlineExpectationsTest

module SensitiveKeyboardCacheTest implements TestSig {
  string getARelevantTag() { result = "hasResult" }

  predicate hasActualResult(Location loc, string element, string tag, string value) {
    exists(AndroidEditableXmlElement el |
      el = getASensitiveCachedInput() and
      loc = el.getLocation() and
      element = el.toString() and
      tag = "hasResult" and
      value = ""
    )
  }
}

import MakeTest<SensitiveKeyboardCacheTest>
