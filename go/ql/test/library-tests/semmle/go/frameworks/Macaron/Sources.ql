import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module RemoteFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "RemoteFlowSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(RemoteFlowSource src |
      src.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = src.toString() and
      value = "" and
      tag = "RemoteFlowSource"
    )
  }
}

import MakeTest<RemoteFlowSourceTest>
