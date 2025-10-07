deprecated module;

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.TaintTracking

/**
 * A taint-tracking configuration for unsafe SSL and TLS versions.
 */
module UnsafeTlsVersionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof UnsafeTlsVersion }

  predicate isSink(DataFlow::Node sink) {
    sink instanceof SslContextGetInstanceSink or
    sink instanceof CreateSslParametersSink or
    sink instanceof SslParametersSetProtocolsSink or
    sink instanceof SetEnabledProtocolsSink
  }
}

module UnsafeTlsVersionFlow = TaintTracking::Global<UnsafeTlsVersionConfig>;

/**
 * A sink that sets protocol versions in `SSLContext`,
 * i.e `SSLContext.getInstance(protocol)`.
 */
class SslContextGetInstanceSink extends DataFlow::ExprNode {
  SslContextGetInstanceSink() {
    exists(StaticMethodCall ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof SslContext and
      m.hasName("getInstance") and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/**
 * A sink that creates `SSLParameters` with specified protocols,
 * i.e. `new SSLParameters(ciphersuites, protocols)`.
 */
class CreateSslParametersSink extends DataFlow::ExprNode {
  CreateSslParametersSink() {
    exists(ConstructorCall cc | cc.getConstructedType() instanceof SslParameters |
      cc.getArgument(1) = this.asExpr()
    )
  }
}

/**
 * A sink that sets protocol versions for `SSLParameters`,
 * i.e. `parameters.setProtocols(versions)`.
 */
class SslParametersSetProtocolsSink extends DataFlow::ExprNode {
  SslParametersSetProtocolsSink() {
    exists(MethodCall ma, Method m | m = ma.getMethod() |
      m.getDeclaringType() instanceof SslParameters and
      m.hasName("setProtocols") and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/**
 * A sink that sets protocol versions for `SSLSocket`, `SSLServerSocket`, and `SSLEngine`,
 * i.e. `socket.setEnabledProtocols(versions)` or `engine.setEnabledProtocols(versions)`.
 */
class SetEnabledProtocolsSink extends DataFlow::ExprNode {
  SetEnabledProtocolsSink() {
    exists(MethodCall ma, Method m, RefType type |
      m = ma.getMethod() and type = m.getDeclaringType()
    |
      (
        type instanceof SslSocket or
        type instanceof SslServerSocket or
        type instanceof SslEngine
      ) and
      m.hasName("setEnabledProtocols") and
      ma.getArgument(0) = this.asExpr()
    )
  }
}

/**
 * Insecure SSL and TLS versions supported by JSSE.
 */
class UnsafeTlsVersion extends StringLiteral {
  UnsafeTlsVersion() {
    this.getValue() = "SSL" or
    this.getValue() = "SSLv2" or
    this.getValue() = "SSLv3" or
    this.getValue() = "TLS" or
    this.getValue() = "TLSv1" or
    this.getValue() = "TLSv1.1"
  }
}

class SslServerSocket extends RefType {
  SslServerSocket() { this.hasQualifiedName("javax.net.ssl", "SSLServerSocket") }
}
