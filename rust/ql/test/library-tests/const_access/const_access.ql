import rust
import utils.test.InlineExpectationsTest
import TestUtils

query predicate constAccess(ConstAccess ca, Const c) { toBeTested(ca) and c = ca.getConst() }

module ConstAccessTest implements TestSig {
  private predicate constAt(Const c, string filepath, int line) {
    c.getLocation().hasLocationInfo(filepath, _, _, line, _)
  }

  string getARelevantTag() { result = "const_access" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(ConstAccess ca, Const c, string filepath, int line |
      toBeTested(ca) and
      location = ca.getLocation() and
      element = ca.toString() and
      tag = "const_access" and
      c = ca.getConst() and
      constAt(c, filepath, line)
    |
      commmentAt(value, filepath, line)
      or
      not commmentAt(_, filepath, line) and
      value = c.getName().getText()
    )
  }
}

import MakeTest<ConstAccessTest>
