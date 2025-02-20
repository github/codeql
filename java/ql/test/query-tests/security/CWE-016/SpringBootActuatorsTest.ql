import java
import semmle.code.java.security.SpringBootActuatorsQuery
import utils.test.InlineExpectationsTest

module SpringBootActuatorsTest implements TestSig {
  string getARelevantTag() { result = "hasExposedSpringBootActuator" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasExposedSpringBootActuator" and
    exists(PermitAllCall permitAllCall | permitAllCall.permitsSpringBootActuators() |
      permitAllCall.getLocation() = location and
      element = permitAllCall.toString() and
      value = ""
    )
  }
}

import MakeTest<SpringBootActuatorsTest>
