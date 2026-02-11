import ql
import codeql_ql.dataflow.DataFlow
import utils.test.InlineExpectationsTest

module GetAStringValueTest implements TestSig {
  string getARelevantTag() { result = "getAStringValue" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Expr e |
      e = any(Call c).getAnArgument() and
      tag = "getAStringValue" and
      value = superNode(e).getAStringValue() and
      location = e.getLocation() and
      element = e.toString()
    )
  }
}

import MakeTest<GetAStringValueTest>
