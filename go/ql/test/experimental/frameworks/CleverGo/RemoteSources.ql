import go
import utils.test.InlineExpectationsTest
import experimental.frameworks.CleverGo

module RemoteFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "remoteFlowSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "remoteFlowSource" and
    exists(DataFlow::CallNode sinkCall, DataFlow::ArgumentNode arg |
      sinkCall.getCalleeName() = "sink" and
      arg = sinkCall.getAnArgument() and
      arg.getAPredecessor*() instanceof RemoteFlowSource
    |
      element = arg.toString() and
      value = "" and
      arg.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

import MakeTest<RemoteFlowSourceTest>
