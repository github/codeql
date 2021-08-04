import java
import semmle.code.java.security.MissingJWTSignatureCheckQuery
import TestUtilities.InlineExpectationsTest

class HasMissingJwtSignatureCheckTest extends InlineExpectationsTest {
  HasMissingJwtSignatureCheckTest() { this = "HasMissingJwtSignatureCheckTest" }

  override string getARelevantTag() { result = "hasMissingJwtSignatureCheck" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasMissingJwtSignatureCheck" and
    exists(JwtParserWithInsecureParseSink sink, JwtParserWithSigningKeyExpr parserExpr |
      sink.asExpr() = parserExpr and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}
