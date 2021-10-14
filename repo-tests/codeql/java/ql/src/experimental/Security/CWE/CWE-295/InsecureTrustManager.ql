/**
 * @name `TrustManager` that accepts all certificates
 * @description Trusting all certificates allows an attacker to perform a machine-in-the-middle attack.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/insecure-trustmanager
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.Encryption
import semmle.code.java.security.SecurityFlag
import DataFlow::PathGraph

/**
 * An insecure `X509TrustManager`.
 * An `X509TrustManager` is considered insecure if it never throws a `CertificateException`
 * and therefore implicitly trusts any certificate as valid.
 */
class InsecureX509TrustManager extends RefType {
  InsecureX509TrustManager() {
    this.getASupertype*() instanceof X509TrustManager and
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
    throwStmt.getThrownExceptionType().getASupertype*() instanceof CertificateException
  |
    throwStmt.getEnclosingCallable() = m
  )
  or
  exists(Method otherMethod | m.polyCalls(otherMethod) |
    mayThrowCertificateException(otherMethod)
    or
    not otherMethod.fromSource() and
    otherMethod.getAnException().getType().getASupertype*() instanceof CertificateException
  )
}

/**
 * A configuration to model the flow of an `InsecureX509TrustManager` to an `SSLContext.init` call.
 */
class InsecureTrustManagerConfiguration extends TaintTracking::Configuration {
  InsecureTrustManagerConfiguration() { this = "InsecureTrustManagerConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(ClassInstanceExpr).getConstructedType() instanceof InsecureX509TrustManager
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess ma, Method m |
      m.hasName("init") and
      m.getDeclaringType() instanceof SSLContext and
      ma.getMethod() = m
    |
      ma.getArgument(1) = sink.asExpr()
    )
  }
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

/** Holds if `node` is guarded by a flag that suggests an intentionally insecure use. */
private predicate isNodeGuardedByFlag(DataFlow::Node node) {
  exists(Guard g | g.controls(node.asExpr().getBasicBlock(), _) |
    g = getASecurityFeatureFlagGuard() or g = getAnInsecureTrustManagerFlagGuard()
  )
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, InsecureTrustManagerConfiguration cfg,
  RefType trustManager
where
  cfg.hasFlowPath(source, sink) and
  not isNodeGuardedByFlag(sink.getNode()) and
  trustManager = source.getNode().asExpr().(ClassInstanceExpr).getConstructedType()
select sink, source, sink, "$@ that is defined $@ and trusts any certificate, is used here.",
  source, "This trustmanager", trustManager, "here"
