import java
import semmle.code.java.security.AndroidIntentRedirectionQuery
import TestUtilities.InlineExpectationsTest

class HasAndroidIntentRedirectionTest extends InlineExpectationsTest {
  HasAndroidIntentRedirectionTest() { this = "HasAndroidIntentRedirectionTest" }

  override string getARelevantTag() { result = "hasAndroidIntentRedirection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasAndroidIntentRedirection" and
    exists(DataFlow::Node src, DataFlow::Node sink, IntentRedirectionConfiguration conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
