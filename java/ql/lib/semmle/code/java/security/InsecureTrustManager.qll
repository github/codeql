/** Provides classes and predicates to reason about insecure `TrustManager`s. */

import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.security.Encryption
private import semmle.code.java.security.SecurityFlag

/** The creation of an insecure `TrustManager`. */
abstract class InsecureTrustManagerSource extends DataFlow::Node { }

private class DefaultInsecureTrustManagerSource extends InsecureTrustManagerSource {
  DefaultInsecureTrustManagerSource() {
    this.asExpr().(ClassInstanceExpr).getConstructedType() instanceof InsecureX509TrustManager
  }
}

/**
 * The use of a `TrustManager` in an SSL context.
 * Intentionally insecure connections are not considered sinks.
 */
abstract class InsecureTrustManagerSink extends DataFlow::Node {
  InsecureTrustManagerSink() { not isGuardedByInsecureFlag(this) }
}

private class DefaultInsecureTrustManagerSink extends InsecureTrustManagerSink {
  DefaultInsecureTrustManagerSink() {
    exists(MethodAccess ma, Method m |
      m.hasName("init") and
      m.getDeclaringType() instanceof SSLContext and
      ma.getMethod() = m
    |
      ma.getArgument(1) = this.asExpr()
    )
  }
}

/** Holds if `node` is guarded by a flag that suggests an intentionally insecure use. */
private predicate isGuardedByInsecureFlag(DataFlow::Node node) {
  exists(Guard g | g.controls(node.asExpr().getBasicBlock(), _) |
    g = getASecurityFeatureFlagGuard() or g = getAnInsecureTrustManagerFlagGuard()
  )
}

/**
 * An insecure `X509TrustManager`.
 * An `X509TrustManager` is considered insecure if it never throws a `CertificateException`
 * and therefore implicitly trusts any certificate as valid.
 */
private class InsecureX509TrustManager extends RefType {
  InsecureX509TrustManager() {
    this.getAnAncestor() instanceof X509TrustManager and
    exists(Method m |
      m.getDeclaringType() = this and
      m.hasName("checkServerTrusted") and
      not mayThrowCertificateException(m)
    )
  }
}

/** The `java.security.cert.CertificateException` class. */
private class CertificateException extends RefType {
  CertificateException() { this.hasQualifiedName("java.security.cert", "CertificateException") }
}

/**
 * Holds if:
 * - `m` may `throw` a `CertificateException`, or
 * - `m` calls another method that may throw, or
 * - `m` calls a method declared to throw a `CertificateException`, but for which no source is available
 */
private predicate mayThrowCertificateException(Method m) {
  exists(ThrowStmt throwStmt |
    throwStmt.getThrownExceptionType().getAnAncestor() instanceof CertificateException
  |
    throwStmt.getEnclosingCallable() = m
  )
  or
  exists(Method otherMethod | m.polyCalls(otherMethod) |
    mayThrowCertificateException(otherMethod)
    or
    not otherMethod.fromSource() and
    otherMethod.getAnException().getType().getAnAncestor() instanceof CertificateException
  )
}

/**
 * Flags suggesting a deliberately insecure `TrustManager` usage.
 */
private class InsecureTrustManagerFlag extends FlagKind {
  InsecureTrustManagerFlag() { this = "InsecureTrustManagerFlag" }

  bindingset[result]
  override string getAFlagName() {
    result
        .regexpMatch("(?i).*(secure|disable|selfCert|selfSign|validat|verif|trust|ignore|nocertificatecheck).*") and
    result != "equalsIgnoreCase"
  }
}

/** Gets a guard that represents a (likely) flag controlling an insecure `TrustManager` use. */
private Guard getAnInsecureTrustManagerFlagGuard() {
  result = any(InsecureTrustManagerFlag flag).getAFlag().asExpr()
}
