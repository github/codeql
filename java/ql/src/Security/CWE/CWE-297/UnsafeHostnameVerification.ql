/**
 * @name Disabled hostname verification
 * @description Accepting any certificate as valid for a host allows an attacker to perform a man-in-the-middle attack.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/insecure-hostname-verifier
 * @tags security
 *       external/cwe/cwe-297
 */

import java

import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import semmle.code.java.security.Encryption

import DataFlow::PathGraph

/**
 * Holds if `m` always returns `true` ignoring any exceptional flow.
 */
private predicate alwaysReturnsTrue(HostnameVerifierVerify m) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = m |
    rs.getResult().(CompileTimeConstantExpr).getBooleanValue() = true
  )
}

/**
 * A class that overrides the `javax.net.ssl.HostnameVerifier.verify` method and **always** returns `true` (ignoring exceptional flow), thus
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

/** Holds if `node` is guarded by a flag that suggests an intentionally insecure feature. */
private predicate isNodeGuardedByFlag(DataFlow::Node node) {
  exists(Guard g | g.controls(node.asExpr().getBasicBlock(), _) |
    g
        .(VarAccess)
        .getVariable()
        .getName()
        .regexpMatch("(?i).*(secure|(en|dis)able|selfCert|selfSign|validat|verif|trust|ignore).*")
  )
}

from DataFlow::PathNode source, DataFlow::PathNode sink, TrustAllHostnameVerifierConfiguration cfg
where cfg.hasFlowPath(source, sink) and not isNodeGuardedByFlag(sink.getNode())
select sink, source, sink, "$@ that accepts any certificate as valid, is used here.", source,
  "This hostname verifier"
