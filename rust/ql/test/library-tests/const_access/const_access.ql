import rust
import utils.test.InlineExpectationsTest
import TestUtils

query predicate constAccess(ConstAccess ca, Const c) { toBeTested(ca) and c = ca.getConst() }

module ConstAccessTest implements TestSig {
  string getARelevantTag() { result = "const_access" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ConstAccess ca |
      toBeTested(ca) and
      location = ca.getLocation() and
      element = ca.toString() and
      tag = "const_access" and
      value = ca.getConst().getName().getText()
    )
  }
}

import MakeTest<ConstAccessTest>
