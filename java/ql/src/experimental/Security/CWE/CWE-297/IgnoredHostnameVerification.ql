/**
 * @name Ignored result of hostname verification
 * @description The method HostnameVerifier.verify() returns a result of hostname verification.
 *              A caller has to check the result and drop the connection if the verification failed.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/ignored-hostname-verification
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.TaintTracking

private class HostnameVerificationCall extends MethodAccess {
  HostnameVerificationCall() {
    getMethod()
        .getDeclaringType()
        .getASupertype*()
        .hasQualifiedName("javax.net.ssl", "HostnameVerifier") and
    getMethod().hasStringSignature("verify(String, SSLSession)")
  }

  predicate ignored() {
    not exists(
      DataFlow::Node source, DataFlow::Node sink, CheckFailedHostnameVerificationConfig config
    |
      this = source.asExpr()
    |
      config.hasFlow(source, sink)
    )
  }
}

private class CheckFailedHostnameVerificationConfig extends TaintTracking::Configuration {
  CheckFailedHostnameVerificationConfig() { this = "CheckFailedHostnameVerificationConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof HostnameVerificationCall
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Guard guard, ThrowStmt throwStmt |
      guard.controls(throwStmt.getBasicBlock(), _) and
      (
        guard = sink.asExpr() or
        guard.(EqualityTest).getAnOperand() = sink.asExpr() or
        guard.(HostnameVerificationCall) = sink.asExpr()
      )
    )
  }
}

from HostnameVerificationCall verification
where verification.ignored()
select verification, "Ignored result of hostname verification."
