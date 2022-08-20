import ql
import codeql_ql.dataflow.DataFlow
import TestUtilities.InlineExpectationsTest

class GetAStringValueTest extends InlineExpectationsTest {
  GetAStringValueTest() { this = "getAStringValue" }

  override string getARelevantTag() { result = "getAStringValue" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr e |
      e = any(Call c).getAnArgument() and
      tag = "getAStringValue" and
      value = superNode(e).getAStringValue() and
      location = e.getLocation() and
      element = e.toString()
    )
  }
}
