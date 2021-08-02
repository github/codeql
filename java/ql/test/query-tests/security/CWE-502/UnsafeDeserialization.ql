import java
import semmle.code.java.security.UnsafeDeserializationQuery
import TestUtilities.InlineExpectationsTest

class UnsafeDeserializationTest extends InlineExpectationsTest {
  UnsafeDeserializationTest() { this = "UnsafeDeserializationTest" }

  override string getARelevantTag() { result = "unsafeDeserialization" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "unsafeDeserialization" and
    exists(DataFlow::Node sink, UnsafeDeserializationConfig conf | conf.hasFlowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
