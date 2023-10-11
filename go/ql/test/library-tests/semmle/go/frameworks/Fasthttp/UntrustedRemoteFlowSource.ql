import go
import TestUtilities.InlineExpectationsTest

module FasthttpTest implements TestSig {
  string getARelevantTag() { result = "UntrustedFlowSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(UntrustedFlowSource q |
      q.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = q.toString() and
      value = q.toString() and
      tag = "UntrustedFlowSource"
    )
  }
}

import MakeTest<FasthttpTest>
