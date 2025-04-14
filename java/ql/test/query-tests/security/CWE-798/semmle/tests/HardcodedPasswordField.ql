import java
import semmle.code.java.security.HardcodedPasswordField
import utils.test.InlineExpectationsTest

module HardcodedPasswordFieldTest implements TestSig {
  string getARelevantTag() { result = "HardcodedPasswordField" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedPasswordField" and
    exists(Expr assigned | passwordFieldAssignedHardcodedValue(_, assigned) |
      assigned.getLocation() = location and
      element = assigned.toString() and
      value = ""
    )
  }
}

import MakeTest<HardcodedPasswordFieldTest>
