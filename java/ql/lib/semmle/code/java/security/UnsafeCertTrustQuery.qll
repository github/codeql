/** Provides taint tracking configurations to be used by unsafe certificate trust queries. */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.UnsafeCertTrust
import semmle.code.java.security.Encryption

/**
 * DEPRECATED: Use `SslEndpointIdentificationFlow` instead.
 *
 * A taint flow configuration for SSL connections created without a proper certificate trust configuration.
 */
deprecated class SslEndpointIdentificationFlowConfig extends TaintTracking::Configuration {
  SslEndpointIdentificationFlowConfig() { this = "SslEndpointIdentificationFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof SslConnectionInit }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SslConnectionCreation }

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    sanitizer instanceof SslUnsafeCertTrustSanitizer
  }
}

/**
 * A taint flow configuration for SSL connections created without a proper certificate trust configuration.
 */
module SslEndpointIdentificationFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SslConnectionInit }

  predicate isSink(DataFlow::Node sink) { sink instanceof SslConnectionCreation }

  predicate isBarrier(DataFlow::Node sanitizer) { sanitizer instanceof SslUnsafeCertTrustSanitizer }
}

/**
 * Taint flow for SSL connections created without a proper certificate trust configuration.
 */
module SslEndpointIdentificationFlow = TaintTracking::Global<SslEndpointIdentificationFlowConfig>;

/**
 * An SSL object that was assigned a safe `SSLParameters` object and can be considered safe.
 */
private class SslConnectionWithSafeSslParameters extends SslUnsafeCertTrustSanitizer {
  SslConnectionWithSafeSslParameters() {
    exists(DataFlow::Node safe, DataFlow::Node sanitizer |
      SafeSslParametersFlow::flowTo(safe) and
      sanitizer = DataFlow::exprNode(safe.asExpr().(Argument).getCall().getQualifier()) and
      DataFlow::localFlow(sanitizer, this)
    )
  }
}

private module SafeSslParametersFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma |
      ma instanceof SafeSetEndpointIdentificationAlgorithm and
      DataFlow::getInstanceArgument(ma) = source.(DataFlow::PostUpdateNode).getPreUpdateNode()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, RefType t | t instanceof SslSocket or t instanceof SslEngine |
      ma.getMethod().hasName("setSSLParameters") and
      ma.getMethod().getDeclaringType().getAnAncestor() = t and
      ma.getArgument(0) = sink.asExpr()
    )
  }
}

private module SafeSslParametersFlow = DataFlow::Global<SafeSslParametersFlowConfig>;

/**
 * A call to `SSLParameters.setEndpointIdentificationAlgorithm` with a non-null and non-empty parameter.
 */
private class SafeSetEndpointIdentificationAlgorithm extends MethodAccess {
  SafeSetEndpointIdentificationAlgorithm() {
    this.getMethod().hasName("setEndpointIdentificationAlgorithm") and
    this.getMethod().getDeclaringType() instanceof SslParameters and
    not this.getArgument(0) instanceof NullLiteral and
    not this.getArgument(0).(CompileTimeConstantExpr).getStringValue() = ""
  }
}
