import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.PartialPathTraversalQuery

class TestRemoteSource extends RemoteFlowSource {
  TestRemoteSource() { this.asParameter().hasName(["dir", "path"]) }

  override string getSourceType() { result = "TestSource" }
}

class Test extends InlineExpectationsTest {
  Test() { this = "PartialPathTraversalFromRemoteTest" }

  override string getARelevantTag() { result = "hasTaintFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node sink | PartialPathTraversalFromRemoteFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
