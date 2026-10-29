import python
import Variables.LoopVariableCapture.LoopVariableCaptureQuery
import utils.test.InlineExpectationsTest

module MethodArgTest implements TestSig {
  string getARelevantTag() { result = "capturedVar" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(CallableExpr capturing, Variable var |
      escapingCapture(capturing, _, var, _, _) and
      element = capturing.toString() and
      location = capturing.getLocation() and
      tag = "capturedVar" and
      value = var.getId()
    )
  }
}

import MakeTest<MethodArgTest>
