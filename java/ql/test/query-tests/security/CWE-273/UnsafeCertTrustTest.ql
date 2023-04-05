import java
import semmle.code.java.security.UnsafeCertTrustQuery
import TestUtilities.InlineExpectationsTest

class UnsafeCertTrustTest extends InlineExpectationsTest {
  UnsafeCertTrustTest() { this = "HasUnsafeCertTrustTest" }

  override string getARelevantTag() { result = "hasUnsafeCertTrust" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasUnsafeCertTrust" and
    exists(Expr unsafeTrust |
      unsafeTrust instanceof RabbitMQEnableHostnameVerificationNotSet
      or
      SslEndpointIdentificationFlow::flowTo(DataFlow::exprNode(unsafeTrust))
    |
      unsafeTrust.getLocation() = location and
      element = unsafeTrust.toString() and
      value = ""
    )
  }
}
