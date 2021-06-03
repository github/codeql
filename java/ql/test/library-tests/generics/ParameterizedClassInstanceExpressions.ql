import default
import TestUtilities.InlineExpectationsTest

class ParameterizedClassInstanceTest extends InlineExpectationsTest {
  ParameterizedClassInstanceTest() { this = "ParameterizedClassInstanceTest" }

  override string getARelevantTag() { result = ["parameterizedNew"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ClassInstanceExpr cie |
      location = cie.getLocation() and
      element = cie.toString() and
      tag = "parameterizedNew" and
      value =
        concat(int idx, Expr typearg |
          typearg = cie.getTypeArgument(idx)
        |
          idx.toString() + typearg.toString(), "," order by idx
        )
    )
  }
}
