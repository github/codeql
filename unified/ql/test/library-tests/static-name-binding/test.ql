import unified
import utils.test.InlineExpectationsTest
import utils.test.TestUtils
import codeql.unified.internal.StaticNameBinding

module StaticDeclAccess implements TestSig {
  string getARelevantTag() { result = "access" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(NameDeclaration decl, Identifier access |
      access = trackNameDeclaration(decl).asIdentifier() and
      not access instanceof NameDeclaration and
      location = access.getLocation() and
      element = access.toString() and
      nameDeclaration(decl, value) and
      tag = "access"
    )
  }
}

import MakeTest<StaticDeclAccess>
