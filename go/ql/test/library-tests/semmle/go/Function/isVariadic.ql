import go
import utils.test.InlineExpectationsTest

module FunctionIsVariadicTest implements TestSig {
  string getARelevantTag() { result = "isVariadic" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(CallExpr ce |
      ce.getTarget().isVariadic() and
      ce.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = ce.toString() and
      value = "" and
      tag = "isVariadic"
    )
  }
}

import MakeTest<FunctionIsVariadicTest>
