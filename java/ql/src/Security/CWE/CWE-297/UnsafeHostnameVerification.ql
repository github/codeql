/**
 * @name Unsafe hostname verification
 * @description Marking a certificate as valid for a host without checking the certificate hostname allows an attacker to perform a machine-in-the-middle attack.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.9
 * @precision high
 * @id java/unsafe-hostname-verification
 * @tags security
 *       external/cwe/cwe-297
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.Encryption
import semmle.code.java.security.SecurityFlag
import DataFlow::PathGraph
private import semmle.code.java.dataflow.ExternalFlow

/**
 * Holds if `m` always returns `true` ignoring any exceptional flow.
 */
private predicate alwaysReturnsTrue(HostnameVerifierVerify m) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = m |
    rs.getResult().(CompileTimeConstantExpr).getBooleanValue() = true
  )
}

/**
 * A class that overrides the `javax.net.ssl.HostnameVerifier.verify` method and **always** returns `true` (though it could also exit due to an uncaught exception), thus
 * accepting any certificate despite a hostname mismatch.
 */
class TrustAllHostnameVerifier extends RefType {
  TrustAllHostnameVerifier() {
    this.getAnAncestor() instanceof HostnameVerifier and
    exists(HostnameVerifierVerify m |
      m.getDeclaringType() = this and
      alwaysReturnsTrue(m)
    )
  }
}

/**
 * A configuration to model the flow of a `TrustAllHostnameVerifier` to a `set(Default)HostnameVerifier` call.
 */
class TrustAllHostnameVerifierConfiguration extends DataFlow::Configuration {
  TrustAllHostnameVerifierConfiguration() { this = "TrustAllHostnameVerifierConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(ClassInstanceExpr).getConstructedType() instanceof TrustAllHostnameVerifier
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof HostnameVerifierSink }

  override predicate isBarrier(DataFlow::Node barrier) {
    // ignore nodes that are in functions that intentionally disable hostname verification
    barrier
        .getEnclosingCallable()
        .getName()
        /*
         * Regex: (_)* :
         * some methods have underscores.
         * Regex: (no|ignore|disable)(strictssl|ssl|verify|verification|hostname)
         * noStrictSSL ignoreSsl
         * Regex: (set)?(accept|trust|ignore|allow)(all|every|any)
         * acceptAll trustAll ignoreAll setTrustAnyHttps
         * Regex: (use|do|enable)insecure
         * useInsecureSSL
         * Regex: (set|do|use)?no.*(check|validation|verify|verification)
         * setNoCertificateCheck
         * Regex: disable
         * disableChecks
         */

        .regexpMatch("^(?i)(_)*((no|ignore|disable)(strictssl|ssl|verify|verification|hostname)" +
            "|(set)?(accept|trust|ignore|allow)(all|every|any)" +
            "|(use|do|enable)insecure|(set|do|use)?no.*(check|validation|verify|verification)|disable).*$")
  }
}

/**
 * A sink that sets the `HostnameVerifier` on `HttpsURLConnection`.
 */
private class HostnameVerifierSink extends DataFlow::Node {
  HostnameVerifierSink() { sinkNode(this, "set-hostname-verifier") }
}

/**
 * Flags suggesting a deliberately unsafe `HostnameVerifier` usage.
 */
private class UnsafeHostnameVerificationFlag extends FlagKind {
  UnsafeHostnameVerificationFlag() { this = "UnsafeHostnameVerificationFlag" }

  bindingset[result]
  override string getAFlagName() {
    result
        .regexpMatch("(?i).*(secure|disable|selfCert|selfSign|validat|verif|trust|ignore|nocertificatecheck).*") and
    result != "equalsIgnoreCase"
  }
}

/** Gets a guard that represents a (likely) flag controlling an unsafe `HostnameVerifier` use. */
private Guard getAnUnsafeHostnameVerifierFlagGuard() {
  result = any(UnsafeHostnameVerificationFlag flag).getAFlag().asExpr()
}

/** Holds if `node` is guarded by a flag that suggests an intentionally insecure use. */
private predicate isNodeGuardedByFlag(DataFlow::Node node) {
  exists(Guard g | g.controls(node.asExpr().getBasicBlock(), _) |
    g = getASecurityFeatureFlagGuard() or g = getAnUnsafeHostnameVerifierFlagGuard()
  )
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, TrustAllHostnameVerifierConfiguration cfg,
  RefType verifier
where
  cfg.hasFlowPath(source, sink) and
  not isNodeGuardedByFlag(sink.getNode()) and
  verifier = source.getNode().asExpr().(ClassInstanceExpr).getConstructedType()
select sink, source, sink,
  "$@ that is defined $@ and accepts any certificate as valid, is used here.", source,
  "This hostname verifier", verifier, "here"
