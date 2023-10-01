import go
import semmle.go.frameworks.GoKit
import TestUtilities.InlineExpectationsTest

module UntrustedFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "source" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(UntrustedFlowSource source |
      source
          .hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
            location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = source.toString() and
      value = "\"" + source.toString() + "\"" and
      tag = "source"
    )
  }
}

import MakeTest<UntrustedFlowSourceTest>
