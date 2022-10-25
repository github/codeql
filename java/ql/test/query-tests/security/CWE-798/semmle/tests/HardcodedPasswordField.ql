import java
import semmle.code.java.security.HardcodedPasswordField
import TestUtilities.InlineExpectationsTest

class HardcodedPasswordFieldTest extends InlineExpectationsTest {
  HardcodedPasswordFieldTest() { this = "HardcodedPasswordFieldTest" }

  override string getARelevantTag() { result = "HardcodedPasswordField" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedPasswordField" and
    exists(Expr assigned | passwordFieldAssignedHardcodedValue(_, assigned) |
      assigned.getLocation() = location and
      element = assigned.toString() and
      value = ""
    )
  }
}
