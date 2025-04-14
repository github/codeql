import java
import semmle.code.java.security.UnsafeCertTrustQuery
import utils.test.InlineExpectationsTest

module UnsafeCertTrustTest implements TestSig {
  string getARelevantTag() { result = "hasUnsafeCertTrust" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<UnsafeCertTrustTest>
