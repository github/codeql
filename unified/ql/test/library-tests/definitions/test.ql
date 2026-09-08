import unified
import utils.test.InlineExpectationsTest
import utils.test.TestUtils
import codeql.Definitions

module DefinitionsTest implements TestSig {
  string getARelevantTag() { result = "definition" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Identifier reference, NameDeclaration definition |
      definitionOf(reference, definition, "name") and
      location = reference.getLocation() and
      element = reference.toString() and
      nameDeclaration(definition, value) and
      tag = "definition"
    )
  }
}

import MakeTest<DefinitionsTest>
