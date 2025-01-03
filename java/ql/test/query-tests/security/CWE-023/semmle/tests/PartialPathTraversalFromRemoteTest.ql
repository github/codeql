import java
import utils.test.InlineExpectationsTest
import semmle.code.java.security.PartialPathTraversalQuery

class TestRemoteSource extends RemoteFlowSource {
  TestRemoteSource() { this.asParameter().hasName(["dir", "path"]) }

  override string getSourceType() { result = "TestSource" }
}

module Test implements TestSig {
  string getARelevantTag() { result = "hasTaintFlow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node sink | PartialPathTraversalFromRemoteFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<Test>
