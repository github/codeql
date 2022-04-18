import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

class SourceTest extends InlineExpectationsTest {
  SourceTest() { this = "SourceTest" }

  override string getARelevantTag() { result = "source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "source" and
    exists(RemoteFlowSource source |
      not source.asParameter().getCallable().getDeclaringType().hasName("DefaultConsumer") and
      source.getLocation() = location and
      element = source.toString() and
      value = ""
    )
  }
}
