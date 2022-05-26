import go
import TestUtilities.InlineExpectationsTest

class FunctionIsVariadicTest extends InlineExpectationsTest {
  FunctionIsVariadicTest() { this = "Function::IsVariadicTest" }

  override string getARelevantTag() { result = "isVariadic" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(CallExpr ce |
      ce.getTarget().isVariadic() and
      ce.hasLocationInfo(file, line, _, _, _) and
      element = ce.toString() and
      value = "" and
      tag = "isVariadic"
    )
  }
}
