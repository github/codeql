/**
 * @name Ignored result of hostname verification
 * @description The method HostnameVerifier.verify() returns a result of hostname verification.
 *              A caller has to check the result and drop the connection if the verification failed.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id java/ignored-hostname-verification
 * @tags security
 *       external/cwe/cwe-297
 */

import java
import semmle.code.java.controlflow.Guards
import semmle.code.java.dataflow.DataFlow

/** The `HostnameVerifier.verify()` method. */
private class HostnameVerifierVerifyMethod extends Method {
  HostnameVerifierVerifyMethod() {
    this.getDeclaringType().getASupertype*().hasQualifiedName("javax.net.ssl", "HostnameVerifier") and
    this.hasStringSignature("verify(String, SSLSession)")
  }
}

/** Defines `HostnameVerifier.verity()` calls that are not wrapped by another `HostnameVerifier`. */
private class HostnameVerificationCall extends MethodAccess {
  HostnameVerificationCall() {
    this.getMethod() instanceof HostnameVerifierVerifyMethod and
    not this.getCaller() instanceof HostnameVerifierVerifyMethod
  }

  /** Holds if the result if the call is not useds. */
  predicate isIgnored() {
    not exists(
      DataFlow::Node source, DataFlow::Node sink, CheckFailedHostnameVerificationConfig config
    |
      this = source.asExpr() and config.hasFlow(source, sink)
    )
  }
}

/**
 * A configuration that tracks data flows from the result of a `HostnameVerifier.vefiry()` call
 * to a condition that controls a throw statement.
 */
private class CheckFailedHostnameVerificationConfig extends DataFlow::Configuration {
  CheckFailedHostnameVerificationConfig() { this = "CheckFailedHostnameVerificationConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof HostnameVerificationCall
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Guard guard, ThrowStmt throwStmt, ReturnStmt returnStmt |
      (
        guard.controls(throwStmt.getBasicBlock(), false) or
        guard.controls(returnStmt.getBasicBlock(), true)
      ) and
      (
        guard = sink.asExpr() or
        guard.(EqualityTest).getAnOperand() = sink.asExpr() or
        guard.(HostnameVerificationCall) = sink.asExpr()
      )
    )
  }
}

from HostnameVerificationCall verification
where verification.isIgnored()
select verification, "Ignored result of hostname verification."
