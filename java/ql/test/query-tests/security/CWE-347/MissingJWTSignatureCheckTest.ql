import java
import semmle.code.java.security.MissingJWTSignatureCheckQuery
import utils.test.InlineExpectationsTest

module HasMissingJwtSignatureCheckTest implements TestSig {
  string getARelevantTag() { result = "hasMissingJwtSignatureCheck" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasMissingJwtSignatureCheck" and
    exists(DataFlow::Node sink | MissingJwtSignatureCheckFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasMissingJwtSignatureCheckTest>
