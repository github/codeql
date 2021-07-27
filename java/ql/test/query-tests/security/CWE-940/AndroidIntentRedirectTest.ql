import java
import semmle.code.java.security.AndroidIntentRedirectQuery
import TestUtilities.InlineExpectationsTest

class HasAndroidIntentRedirectTest extends InlineExpectationsTest {
  HasAndroidIntentRedirectTest() { this = "HasAndroidIntentRedirectTest" }

  override string getARelevantTag() { result = "hasAndroidIntentRedirect" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasAndroidIntentRedirect" and
    exists(DataFlow::Node src, DataFlow::Node sink, IntentRedirectConfiguration conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
