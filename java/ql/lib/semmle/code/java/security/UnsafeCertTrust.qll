/** Provides classes and predicates to reason about unsafe certificate trust vulnerablities. */

import java
private import semmle.code.java.frameworks.Networking
private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.DataFlow

/**
 * The creation of an object that prepares an SSL connection.
 *
 * This is a source for `SslEndpointIdentificationFlowConfig`.
 */
class SslConnectionInit extends DataFlow::Node {
  SslConnectionInit() {
    exists(MethodCall ma, Method m |
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
    exists(MethodCall ma, Method m |
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
 * An SSL object that correctly verifies hostnames, or doesn't need to (for instance, because it's a server).
 *
 * This is a sanitizer for `SslEndpointIdentificationFlowConfig`.
 */
abstract class SslUnsafeCertTrustSanitizer extends DataFlow::Node { }

/**
 * An `SSLEngine` set in server mode.
 */
private class SslEngineServerMode extends SslUnsafeCertTrustSanitizer {
  SslEngineServerMode() {
    exists(MethodCall ma, Method m |
      m.hasName("setUseClientMode") and
      m.getDeclaringType().getAnAncestor() instanceof SslEngine and
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
private predicate isSslSocket(MethodCall createSocket) {
  createSocket = any(CastExpr ce | ce.getType() instanceof SslSocket).getExpr()
  or
  createSocket.getQualifier().getType().(RefType).getAnAncestor() instanceof SslSocketFactory
}

/**
 * A call to a method that enables SSL (`useSslProtocol` or `setSslContextFactory`)
 * on an instance of `com.rabbitmq.client.ConnectionFactory` that doesn't set `enableHostnameVerification`.
 */
class RabbitMQEnableHostnameVerificationNotSet extends MethodCall {
  RabbitMQEnableHostnameVerificationNotSet() {
    this.getMethod().hasName(["useSslProtocol", "setSslContextFactory"]) and
    this.getMethod().getDeclaringType() instanceof RabbitMQConnectionFactory and
    exists(Variable v |
      v.getType() instanceof RabbitMQConnectionFactory and
      this.getQualifier() = v.getAnAccess() and
      not exists(MethodCall ma |
        ma.getMethod().hasName("enableHostnameVerification") and
        ma.getQualifier() = v.getAnAccess()
      )
    )
  }
}

private class RabbitMQConnectionFactory extends RefType {
  RabbitMQConnectionFactory() { this.hasQualifiedName("com.rabbitmq.client", "ConnectionFactory") }
}
