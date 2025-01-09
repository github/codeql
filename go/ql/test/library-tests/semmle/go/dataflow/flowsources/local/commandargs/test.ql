import go
import ModelValidation
import utils.test.InlineExpectationsTest

module SourceTest implements TestSig {
  string getARelevantTag() { result = "source" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ActiveThreatModelSource s |
      s.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = s.toString() and
      value = "" and
      tag = "source"
    )
  }
}

import MakeTest<SourceTest>
