import go
import TestUtilities.InlineExpectationsTest
import experimental.frameworks.Fiber

class UntrustedFlowSourceTest extends InlineExpectationsTest {
  UntrustedFlowSourceTest() { this = "UntrustedFlowSourceTest" }

  override string getARelevantTag() { result = "untrustedFlowSource" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "untrustedFlowSource" and
    exists(DataFlow::CallNode sinkCall, DataFlow::ArgumentNode arg |
      sinkCall.getCalleeName() = "sink" and
      arg = sinkCall.getAnArgument() and
      arg.getAPredecessor*() instanceof UntrustedFlowSource
    |
      element = arg.toString() and
      value = "" and
      arg.hasLocationInfo(file, line, _, _, _)
    )
  }
}
