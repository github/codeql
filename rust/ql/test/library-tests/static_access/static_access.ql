import rust
import utils.test.InlineExpectationsTest
import TestUtils

query predicate staticAccess(StaticAccess sa, Static s) { toBeTested(sa) and s = sa.getStatic() }

module StaticAccessTest implements TestSig {
  private predicate staticAt(Static s, string filepath, int line) {
    s.getLocation().hasLocationInfo(filepath, _, _, line, _)
  }

  string getARelevantTag() { result = "static_access" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(StaticAccess sa, Static s, string filepath, int line |
      toBeTested(sa) and
      location = sa.getLocation() and
      element = sa.toString() and
      tag = "static_access" and
      s = sa.getStatic() and
      staticAt(s, filepath, line)
    |
      commmentAt(value, filepath, line)
      or
      not commmentAt(_, filepath, line) and
      value = s.getName().getText()
    )
  }
}

import MakeTest<StaticAccessTest>
