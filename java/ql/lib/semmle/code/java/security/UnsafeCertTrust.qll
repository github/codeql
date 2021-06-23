/** Provides classes and predicates to reason about unsafe certificate trust vulnerablities. */

import java
private import semmle.code.java.frameworks.Networking
private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.DataFlow2

/**
 * The creation of an object that prepares an SSL connection.
 *
 * This is a source for `SslEndpointIdentificationFlowConfig`.
 */
class SslConnectionInit extends DataFlow::Node {
  SslConnectionInit() {
    exists(MethodAccess ma, Method m |
      this.asExpr() = ma and
      ma.getMethod() = m
    |
      m instanceof CreateSslEngineMethod
      or
      m instanceof CreateSocketMethod and isSslSocket(ma)
    )
  }
}

/**
 * A call to a method that establishes an SSL connection.
 *
 * This is a sink for `SslEndpointIdentificationFlowConfig`.
 */
class SslConnectionCreation extends DataFlow::Node {
  SslConnectionCreation() {
    exists(MethodAccess ma, Method m |
      m instanceof BeginHandshakeMethod or
      m instanceof SslWrapMethod or
      m instanceof SslUnwrapMethod or
      m instanceof SocketGetOutputStreamMethod
    |
      ma.getMethod() = m and
      this.asExpr() = ma.getQualifier()
    )
  }
}

/**
 * An SSL object that correctly verifies hostnames, or doesn't need to (because e.g. it's a server).
 *
 * This is a sanitizer for `SslEndpointIdentificationFlowConfig`.
 */
abstract class SslUnsafeCertTrustSanitizer extends DataFlow::Node { }

/**
 * An SSL object that was assigned a safe `SSLParameters` object and can be considered safe.
 */
private class SslConnectionWithSafeSslParameters extends SslUnsafeCertTrustSanitizer {
  SslConnectionWithSafeSslParameters() {
    exists(SafeSslParametersFlowConfig config, DataFlow::Node safe, DataFlow::Node sanitizer |
      config.hasFlowTo(safe) and
      sanitizer = DataFlow::exprNode(safe.asExpr().(Argument).getCall().getQualifier()) and
      DataFlow::localFlow(sanitizer, this)
    )
  }
}

/**
 * An `SSLEngine` set in server mode.
 */
private class SslEngineServerMode extends SslUnsafeCertTrustSanitizer {
  SslEngineServerMode() {
    exists(MethodAccess ma, Method m |
      m.hasName("setUseClientMode") and
      m.getDeclaringType().getASupertype*() instanceof SSLEngine and
      ma.getMethod() = m and
      ma.getArgument(0).(CompileTimeConstantExpr).getBooleanValue() = false and
      this.asExpr() = ma.getQualifier()
    )
  }
}

/**
 * Holds if the return value of `createSocket` is cast to `SSLSocket`
 * or the qualifier of `createSocket` is an instance of `SSLSocketFactory`.
 */
private predicate isSslSocket(MethodAccess createSocket) {
  exists(Variable ssl, CastExpr ce |
    ce.getExpr() = createSocket and
    ce.getControlFlowNode().getASuccessor().(VariableAssign).getDestVar() = ssl and
    ssl.getType() instanceof SSLSocket
  )
  or
  createSocket.getQualifier().getType().(RefType).getASupertype*() instanceof SSLSocketFactory
}

private class SafeSslParametersFlowConfig extends DataFlow2::Configuration {
  SafeSslParametersFlowConfig() { this = "SafeSslParametersFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma |
      ma instanceof SafeSetEndpointIdentificationAlgorithm and
      DataFlow::getInstanceArgument(ma) = source.(DataFlow::PostUpdateNode).getPreUpdateNode()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, RefType t | t instanceof SSLSocket or t instanceof SSLEngine |
      ma.getMethod().hasName("setSSLParameters") and
      ma.getMethod().getDeclaringType().getASupertype*() = t and
      ma.getArgument(0) = sink.asExpr()
    )
  }
}

private class SafeSetEndpointIdentificationAlgorithm extends MethodAccess {
  SafeSetEndpointIdentificationAlgorithm() {
    this.getMethod().hasName("setEndpointIdentificationAlgorithm") and
    this.getMethod().getDeclaringType() instanceof SSLParameters and
    not this.getArgument(0) instanceof NullLiteral and
    not this.getArgument(0).(CompileTimeConstantExpr).getStringValue().length() = 0
  }
}

/**
 * A call to the method `useSslProtocol` on an instance of `com.rabbitmq.client.ConnectionFactory`
 * that doesn't set `enableHostnameVerification`.
 */
class RabbitMQEnableHostnameVerificationNotSet extends MethodAccess {
  RabbitMQEnableHostnameVerificationNotSet() {
    this.getMethod().hasName("useSslProtocol") and
    this.getMethod().getDeclaringType() instanceof RabbitMQConnectionFactory and
    exists(Variable v |
      v.getType() instanceof RabbitMQConnectionFactory and
      this.getQualifier() = v.getAnAccess() and
      not exists(MethodAccess ma |
        ma.getMethod().hasName("enableHostnameVerification") and
        ma.getQualifier() = v.getAnAccess()
      )
    )
  }
}

private class RabbitMQConnectionFactory extends RefType {
  RabbitMQConnectionFactory() { this.hasQualifiedName("com.rabbitmq.client", "ConnectionFactory") }
}
