import go
import TestUtilities.InlineExpectationsTest
import experimental.frameworks.Fiber

module UntrustedFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "untrustedFlowSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "untrustedFlowSource" and
    exists(DataFlow::CallNode sinkCall, DataFlow::ArgumentNode arg |
      sinkCall.getCalleeName() = "sink" and
      arg = sinkCall.getAnArgument() and
      arg.getAPredecessor*() instanceof UntrustedFlowSource
    |
      element = arg.toString() and
      value = "" and
      arg.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

import MakeTest<UntrustedFlowSourceTest>
