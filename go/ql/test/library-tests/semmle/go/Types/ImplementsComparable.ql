import go
import TestUtilities.InlineExpectationsTest

class ImplementsComparableTest extends InlineExpectationsTest {
  ImplementsComparableTest() { this = "ImplementsComparableTest" }

  override string getARelevantTag() { result = "implementsComparable" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    // file = "interface.go" and
    tag = "implementsComparable" and
    exists(TypeSpec ts |
      ts.getName().matches("testComparable%") and
      ts.getATypeParameterDecl().getTypeConstraint().implementsComparable()
    |
      ts.hasLocationInfo(file, line, _, _, _) and
      element = ts.getName() and
      value = ""
    )
  }
}
