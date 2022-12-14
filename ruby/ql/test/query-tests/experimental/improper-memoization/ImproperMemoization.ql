import codeql.ruby.AST
import TestUtilities.InlineExpectationsTest
import codeql.ruby.security.ImproperMemoizationQuery

class ImproperMemoizationTest extends InlineExpectationsTest {
  ImproperMemoizationTest() { this = "ImproperMemoizationTest" }

  override string getARelevantTag() { result = "result" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "result" and
    value = "BAD" and
    exists(Expr e |
      isImproperMemoizationMethod(e, _, _) and
      location = e.getLocation() and
      element = e.toString()
    )
  }
}

from Method m, Parameter p, AssignLogicalOrExpr s
where isImproperMemoizationMethod(m, p, s)
select m, p, s
