import java
import semmle.code.java.security.StaticInitializationVectorQuery
import TestUtilities.InlineExpectationsTest

class StaticInitializationVectorTest extends InlineExpectationsTest {
  StaticInitializationVectorTest() { this = "StaticInitializationVectorTest" }

  override string getARelevantTag() { result = "staticInitializationVector" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "staticInitializationVector" and
    exists(DataFlow::Node sink, StaticInitializationVectorConfig conf | conf.hasFlowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
