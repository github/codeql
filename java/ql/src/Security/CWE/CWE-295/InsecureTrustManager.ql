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
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.security.Encryption
import DataFlow::PathGraph

/**
 * Models an insecure `X509TrustManager`.
 * An `X509TrustManager` is considered insecure if it never throws a `CertificatException` thereby accepting any certificate as valid.
 */
class InsecureX509TrustManager extends RefType {
  InsecureX509TrustManager() {
    getASupertype*() instanceof X509TrustManager and
    exists(Method m |
      m.getDeclaringType() = this and
      m.hasName("checkServerTrusted") and
      not mayThrowCertificateException(m)
    )
  }
}

/** The `java.security.cert.CertificateException` class. */
private class CertificatException extends RefType {
  CertificatException() { hasQualifiedName("java.security.cert", "CertificateException") }
}

/**
 *Holds if:
 * - `m` may `throw` an `CertificatException`
 * - `m` calls another method that may throw
 * - `m` calls a method that declares to throw an `CertificatExceptio`, but for which no source is available
 */
private predicate mayThrowCertificateException(Method m) {
  exists(Stmt stmt | m.getBody().getAChild*() = stmt |
    stmt.(ThrowStmt).getThrownExceptionType().getASupertype*() instanceof CertificatException
  )
  or
  exists(Method otherMethod | m.polyCalls(otherMethod) |
    mayThrowCertificateException(otherMethod)
    or
    not otherMethod.fromSource() and
    otherMethod.getAnException().getType().getASupertype*() instanceof CertificatException
  )
}

/**
 * A configuration to model the flow of a `InsecureX509TrustManager` to an `SSLContext.init` call.
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

  override predicate isSanitizer(DataFlow::Node barrier) {
    // ignore nodes that are in functions that intentionally trust all certificates
    barrier
        .getEnclosingCallable()
        .getName()
        /*
         * Regex: (_)* :
         * some methods have underscores.
         * Regex: (no|ignore|disable)(strictssl|ssl|verify|verification)
         * noStrictSSL ignoreSsl
         * Regex: (set)?(accept|trust|ignore|allow)(all|every|any|selfsigned)
         * acceptAll trustAll ignoreAll setTrustAnyHttps
         * Regex: (use|do|enable)insecure
         * useInsecureSSL
         * Regex: (set|do|use)?no.*(check|validation|verify|verification)
         * setNoCertificateCheck
         * Regex: disable
         * disableChecks
         */

        .regexpMatch("^(?i)(_)*((no|ignore|disable)(strictssl|ssl|verify|verification)" +
            "|(set)?(accept|trust|ignore|allow)(all|every|any|selfsigned)" +
            "|(use|do|enable)insecure|(set|do|use)?no.*(check|validation|verify|verification)|disable).*$")
  }
}

bindingset[result]
private string getAFlagName() {
  result
      .regexpMatch("(?i).*(secure|disable|selfCert|selfSign|validat|verif|trust|ignore|nocertificatecheck).*")
}

/**
 * A flag has to either be of type `String`, `boolean` or `Boolean`.
 */
private class FlagType extends Type {
  FlagType() {
    this instanceof TypeString
    or
    this instanceof BooleanType
  }
}

private predicate isEqualsIgnoreCaseMethodAccess(MethodAccess ma) {
  ma.getMethod().hasName("equalsIgnoreCase") and
  ma.getMethod().getDeclaringType() instanceof TypeString
}

/** Holds if `source` should is considered a flag. */
private predicate isFlag(DataFlow::Node source) {
  exists(VarAccess v | v.getVariable().getName() = getAFlagName() |
    source.asExpr() = v and v.getType() instanceof FlagType
  )
  or
  exists(StringLiteral s | s.getRepresentedString() = getAFlagName() | source.asExpr() = s)
  or
  exists(MethodAccess ma | ma.getMethod().getName() = getAFlagName() |
    source.asExpr() = ma and
    ma.getType() instanceof FlagType and
    not isEqualsIgnoreCaseMethodAccess(ma)
  )
}

/** Holds if there is flow from `node1` to `node2` either due to local flow or due to custom flow steps. */
private predicate flagFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
  DataFlow::localFlowStep(node1, node2)
  or
  exists(MethodAccess ma | ma.getMethod() = any(EnvReadMethod m) |
    ma = node2.asExpr() and ma.getAnArgument() = node1.asExpr()
  )
  or
  exists(MethodAccess ma |
    ma.getMethod().hasName("parseBoolean") and
    ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "Boolean")
  |
    ma = node2.asExpr() and ma.getAnArgument() = node1.asExpr()
  )
}

/** Gets a guard that depends on a flag. */
private Guard getAGuard() {
  exists(DataFlow::Node source, DataFlow::Node sink |
    isFlag(source) and
    flagFlowStep*(source, sink) and
    sink.asExpr() = result
  )
}

/** Holds if `node` is guarded by a flag that suggests an intentionally insecure feature. */
private predicate isNodeGuardedByFlag(DataFlow::Node node) {
  exists(Guard g | g.controls(node.asExpr().getBasicBlock(), _) | g = getAGuard())
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
