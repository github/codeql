import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import experimental.dataflow.testConfig

class CaptureTest extends InlineExpectationsTest {
  CaptureTest() { this = "CaptureTest" }

  override string getARelevantTag() { result = "captured" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink | exists(TestConfiguration cfg | cfg.hasFlowTo(sink)) |
      location = sink.getLocation() and
      tag = "captured" and
      value = "" and
      element = sink.toString()
    )
  }
}
