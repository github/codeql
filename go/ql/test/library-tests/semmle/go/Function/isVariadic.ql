import go
import TestUtilities.InlineExpectationsTest

class FunctionIsVariadicTest extends InlineExpectationsTest {
  FunctionIsVariadicTest() { this = "Function::IsVariadicTest" }

  override string getARelevantTag() { result = "isVariadic" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
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
