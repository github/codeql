import java
import semmle.code.java.security.MissingJWTSignatureCheckQuery
import TestUtilities.InlineExpectationsTest

class HasMissingJwtSignatureCheckTest extends InlineExpectationsTest {
  HasMissingJwtSignatureCheckTest() { this = "HasMissingJwtSignatureCheckTest" }

  override string getARelevantTag() { result = "hasMissingJwtSignatureCheck" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasMissingJwtSignatureCheck" and
    exists(DataFlow::Node sink, MissingJwtSignatureCheckConf conf | conf.hasFlowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
