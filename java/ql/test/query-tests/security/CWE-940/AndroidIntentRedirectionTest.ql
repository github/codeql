import java
import semmle.code.java.security.AndroidIntentRedirectionQuery
import TestUtilities.InlineExpectationsTest

module HasAndroidIntentRedirectionTest implements TestSig {
  string getARelevantTag() { result = "hasAndroidIntentRedirection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasAndroidIntentRedirection" and
    exists(DataFlow::Node sink | IntentRedirectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasAndroidIntentRedirectionTest>
