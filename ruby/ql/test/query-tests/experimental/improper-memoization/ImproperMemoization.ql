import codeql.ruby.AST
import utils.test.InlineExpectationsTest
import codeql.ruby.security.ImproperMemoizationQuery

module ImproperMemoizationTest implements TestSig {
  string getARelevantTag() { result = "result" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "result" and
    value = "BAD" and
    exists(Expr e |
      isImproperMemoizationMethod(e, _, _) and
      location = e.getLocation() and
      element = e.toString()
    )
  }
}

import MakeTest<ImproperMemoizationTest>

from Method m, Parameter p, AssignLogicalOrExpr s
where isImproperMemoizationMethod(m, p, s)
select m, p, s
