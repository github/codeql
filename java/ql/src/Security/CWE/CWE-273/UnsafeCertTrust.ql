/**
 * @name Unsafe certificate trust
 * @description SSLSocket/SSLEngine ignores all SSL certificate validation
 *              errors when establishing an HTTPS connection, thereby making
 *              the app vulnerable to man-in-the-middle attacks.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/unsafe-cert-trust
 * @tags security
 *       external/cwe/cwe-273
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.UnsafeCertTrust

class SslEndpointIdentificationFlowConfig extends TaintTracking::Configuration {
  SslEndpointIdentificationFlowConfig() { this = "SslEndpointIdentificationFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof SslConnectionInit }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SslConnectionCreation }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof SslUnsafeCertTrustSanitizer
  }
}

from Expr unsafeTrust
where
  unsafeTrust instanceof RabbitMQEnableHostnameVerificationNotSet or
  exists(SslEndpointIdentificationFlowConfig config |
    config.hasFlowTo(DataFlow::exprNode(unsafeTrust))
  )
select unsafeTrust, "Unsafe configuration of trusted certificates"
