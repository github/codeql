import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking
import DataFlow
import PathGraph

/**
 * A taint-tracking configuration for unsafe SSL and TLS versions.
 */
class UnsafeTlsVersionConfig extends TaintTracking::Configuration {
  UnsafeTlsVersionConfig() { this = "UnsafeTlsVersion::UnsafeTlsVersionConfig" }

  override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof UnsafeTlsVersion }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof SslContextGetInstanceSink or
    sink instanceof CreateSslParametersSink or
    sink instanceof SslParametersSetProtocolsSink or
    sink instanceof SetEnabledProtocolsSink
  }
}

/**
 * A sink that sets protocol versions in `SSLContext`,
 * i.e `SSLContext.getInstance(protocol)`.
 */
class SslContextGetInstanceSink extends DataFlow::ExprNode {
  SslContextGetInstanceSink() {
    exists(StaticMethodAccess ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof SSLContext and
      m.hasName("getInstance") and
      ma.getArgument(0) = asExpr()
    )
  }
}

/**
 * A sink that creates `SSLParameters` with specified protocols,
 * i.e. `new SSLParameters(ciphersuites, protocols)`.
 */
class CreateSslParametersSink extends DataFlow::ExprNode {
  CreateSslParametersSink() {
    exists(ConstructorCall cc | cc.getConstructedType() instanceof SSLParameters |
      cc.getArgument(1) = asExpr()
    )
  }
}

/**
 * A sink that sets protocol versions for `SSLParameters`,
 * i.e. `parameters.setProtocols(versions)`.
 */
class SslParametersSetProtocolsSink extends DataFlow::ExprNode {
  SslParametersSetProtocolsSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof SSLParameters and
      m.hasName("setProtocols") and
      ma.getArgument(0) = asExpr()
    )
  }
}

/**
 * A sink that sets protocol versions for `SSLSocket`, `SSLServerSocket`, and `SSLEngine`,
 * i.e. `socket.setEnabledProtocols(versions)` or `engine.setEnabledProtocols(versions)`.
 */
class SetEnabledProtocolsSink extends DataFlow::ExprNode {
  SetEnabledProtocolsSink() {
    exists(MethodAccess ma, Method m, RefType type |
      m = ma.getMethod() and type = m.getDeclaringType()
    |
      (
        type instanceof SSLSocket or
        type instanceof SSLServerSocket or
        type instanceof SSLEngine
      ) and
      m.hasName("setEnabledProtocols") and
      ma.getArgument(0) = asExpr()
    )
  }
}

/**
 * Insecure SSL and TLS versions supported by JSSE.
 */
class UnsafeTlsVersion extends StringLiteral {
  UnsafeTlsVersion() {
    getValue() = "SSL" or
    getValue() = "SSLv2" or
    getValue() = "SSLv3" or
    getValue() = "TLS" or
    getValue() = "TLSv1" or
    getValue() = "TLSv1.1"
  }
}

class SSLServerSocket extends RefType {
  SSLServerSocket() { hasQualifiedName("javax.net.ssl", "SSLServerSocket") }
}
