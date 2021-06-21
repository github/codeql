/** Provides classes and predicates to reason about unsafe certificate trust vulnerablities. */

import java
private import semmle.code.java.frameworks.Networking
private import semmle.code.java.security.Encryption
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.DataFlow2

/**
 * The creation of an object that prepares an SSL connection.
 */
class SslConnectionInit extends DataFlow::Node {
  SslConnectionInit() {
    this.asExpr().(MethodAccess).getMethod() instanceof CreateSslEngineMethod or
    this.asExpr().(MethodAccess).getMethod() instanceof CreateSocketMethod
  }
}

/**
 * A call to a method that establishes an SSL connection.
 */
class SslConnectionCreation extends DataFlow::Node {
  SslConnectionCreation() {
    exists(MethodAccess ma, Method m |
      m instanceof GetSslSessionMethod or
      m instanceof SocketConnectMethod
    |
      ma.getMethod() = m and
      this.asExpr() = ma.getQualifier()
    )
    or
    // calls to SocketFactory.createSocket with parameters immediately create the connection
    exists(MethodAccess ma, Method m |
      ma.getMethod() = m and
      m instanceof CreateSocket and
      m.getNumberOfParameters() > 0
    |
      this.asExpr() = ma
    )
  }
}

/**
 * An SSL object that was assigned a safe `SSLParameters` object an can be considered safe.
 */
class SslConnectionWithSafeSslParameters extends Expr {
  SslConnectionWithSafeSslParameters() {
    exists(SafeSslParametersFlowConfig config, DataFlow::Node safe |
      config.hasFlowTo(safe) and this = safe.asExpr().(Argument).getCall().getQualifier()
    )
  }
}

private class SafeSslParametersFlowConfig extends DataFlow2::Configuration {
  SafeSslParametersFlowConfig() { this = "SafeSslParametersFlowConfig" }

  override predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma |
      ma instanceof SafeSetEndpointIdentificationAlgorithm and
      ma.getQualifier() = source.asExpr()
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
 * that doesn't have `enableHostnameVerification` set.
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
