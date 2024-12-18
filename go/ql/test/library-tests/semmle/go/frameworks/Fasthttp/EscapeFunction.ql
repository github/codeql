import go
import utils.test.InlineExpectationsTest

module FasthttpTest implements TestSig {
  string getARelevantTag() { result = "Sanitizer" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(EscapeFunction ef, DataFlow::CallNode cn | cn = ef.getACall() |
      cn.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = cn.getArgument(1).toString() and
      value = cn.getArgument(1).toString() and
      tag = "Sanitizer"
    )
  }
}

import MakeTest<FasthttpTest>
