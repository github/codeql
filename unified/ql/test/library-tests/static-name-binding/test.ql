import unified
import utils.test.InlineExpectationsTest
import utils.test.TestUtils
import codeql.unified.internal.StaticNameBinding

module StaticDeclAccess implements TestSig {
  string getARelevantTag() { result = "access" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(NameBinding decl, Identifier access |
      decl = getStaticBindingTarget(access) and
      not access instanceof NameBinding and
      location = access.getLocation() and
      element = access.toString() and
      nameBinding(decl, value) and
      tag = "access"
    )
  }
}

import MakeTest<StaticDeclAccess>
