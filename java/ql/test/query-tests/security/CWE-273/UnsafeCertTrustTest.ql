import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.UnsafeCertTrust
import TestUtilities.InlineExpectationsTest

class Conf extends TaintTracking::Configuration {
  Conf() { this = "qltest:cwe:unsafe-cert-trust" }

  override predicate isSource(DataFlow::Node source) { source instanceof SslConnectionInit }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SslConnectionCreation }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof SslConnectionWithSafeSslParameters
  }
}

class UnsafeCertTrustTest extends InlineExpectationsTest {
  UnsafeCertTrustTest() { this = "HasUnsafeCertTrustTest" }

  override string getARelevantTag() { result = "hasUnsafeCertTrust" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasUnsafeCertTrust" and
    exists(Expr unsafeTrust |
      unsafeTrust instanceof X509TrustAllManagerInit
      or
      unsafeTrust instanceof RabbitMQEnableHostnameVerificationNotSet
      or
      exists(Conf config | config.hasFlowTo(DataFlow::exprNode(unsafeTrust)))
    |
      unsafeTrust.getLocation() = location and
      element = unsafeTrust.toString() and
      value = ""
    )
  }
}
