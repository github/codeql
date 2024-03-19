import go
import TestUtilities.InlineExpectationsTest

module UntrustedFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "UntrustedFlowSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(UntrustedFlowSource src |
      src.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = src.toString() and
      value = "" and
      tag = "UntrustedFlowSource"
    )
  }
}

import MakeTest<UntrustedFlowSourceTest>
