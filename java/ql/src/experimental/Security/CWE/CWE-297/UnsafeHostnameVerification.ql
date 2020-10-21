/**
 * @name Unsafe certificate trust and improper hostname verification
 * @description Unsafe implementation of the interface X509TrustManager, HostnameVerifier, and SSLSocket/SSLEngine ignores all SSL certificate validation errors when establishing an HTTPS connection, thereby making the app vulnerable to man-in-the-middle attacks.
 * @kind problem
 * @id java/unsafe-cert-trust
 * @tags security
 *       external/cwe-273
 */

import java
import semmle.code.java.security.Encryption
import semmle.code.java.dataflow.DataFlow

/** A return statement that returns `true`. */
private class TrueReturnStmt extends ReturnStmt {
  TrueReturnStmt() { getResult().(CompileTimeConstantExpr).getBooleanValue() = true }
}

/**
 * Holds if `m` always returns `true` ignoring any exceptional flow.
 */
private predicate alwaysReturnsTrue(HostnameVerifierVerify m) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = m | rs instanceof TrueReturnStmt)
}

/**
 * A class that overrides the `javax.net.ssl.HostnameVerifier.verify` method and **always** returns `true`, thus
 * accepting any certificate despite a hostname mismatch.
 */
class TrustAllHostnameVerifier extends RefType {
  TrustAllHostnameVerifier() {
    this.getASupertype*() instanceof HostnameVerifier and
    exists(HostnameVerifierVerify m |
      m.getDeclaringType() = this and
      alwaysReturnsTrue(m)
    )
  }
}

class SSLEngine extends RefType {
  SSLEngine() { this.hasQualifiedName("javax.net.ssl", "SSLEngine") }
}

class Socket extends RefType {
  Socket() { this.hasQualifiedName("java.net", "Socket") }
}

class SocketFactory extends RefType {
  SocketFactory() { this.hasQualifiedName("javax.net", "SocketFactory") }
}

class SSLSocket extends RefType {
  SSLSocket() { this.hasQualifiedName("javax.net.ssl", "SSLSocket") }
}

/**
 * A configuration to model the flow of a `TrustAllHostnameVerifier` to a `set(Default)HostnameVerifier` call.
 */
class TrustAllHostnameVerifierConfiguration extends DataFlow::Configuration {
  TrustAllHostnameVerifierConfiguration() { this = "TrustAllHostnameVerifierConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(ClassInstanceExpr).getConstructedType() instanceof TrustAllHostnameVerifier
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m |
      (m instanceof SetDefaultHostnameVerifierMethod or m instanceof SetHostnameVerifierMethod) and
      ma.getMethod() = m
    |
      ma.getArgument(0) = sink.asExpr()
    )
  }
}

from DataFlow::Node source, DataFlow::Node sink, TrustAllHostnameVerifierConfiguration cfg
where cfg.hasFlow(source, sink)
select sink, "Unsafe configuration of trusted certificates"
