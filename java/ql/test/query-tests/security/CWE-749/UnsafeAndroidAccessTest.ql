import java
import semmle.code.java.security.UnsafeAndroidAccessQuery
import TestUtilities.InlineExpectationsTest

class UnsafeAndroidAccessTest extends InlineExpectationsTest {
  UnsafeAndroidAccessTest() { this = "HasUnsafeAndroidAccess" }

  override string getARelevantTag() { result = "hasUnsafeAndroidAccess" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasUnsafeAndroidAccess" and
    exists(DataFlow::Node src, DataFlow::Node sink, FetchUntrustedResourceConfiguration conf |
      conf.hasFlow(src, sink)
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
