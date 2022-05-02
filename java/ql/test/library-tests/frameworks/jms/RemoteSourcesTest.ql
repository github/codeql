import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

class JmsRemoteSourcesTest extends InlineExpectationsTest {
  JmsRemoteSourcesTest() { this = "JmsRemoteSourcesTest" }

  override string getARelevantTag() { result = "source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "source" and
    exists(RemoteFlowSource source |
      location = source.getLocation() and element = source.toString() and value = ""
    )
  }
}
