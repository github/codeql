import python
import Variables.LoopVariableCapture.LoopVariableCaptureQuery
import utils.test.InlineExpectationsTest

module MethodArgTest implements TestSig {
  string getARelevantTag() { result = ["capturedVar"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(CallableExpr capturing, AstNode loop, Variable var |
      escapingCapture(capturing, loop, var, _, _) and
      element = capturing.toString() and
      location = capturing.getLocation() and
      tag = "capturedVar" and
      value = var.getId()
    )
  }
}

import MakeTest<MethodArgTest>
