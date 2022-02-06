/**
 * @name Ignored result of hostname verification
 * @description The method HostnameVerifier.verify() returns a result of hostname verification.
 *              A caller has to check the result and drop the connection if the verification failed.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/ignored-hostname-verification
 * @tags security
 *       external/cwe/cwe-297
 */

import java

/** The `HostnameVerifier.verify()` method. */
private class HostnameVerifierVerifyMethod extends Method {
  HostnameVerifierVerifyMethod() {
    this.getDeclaringType().getASupertype*().hasQualifiedName("javax.net.ssl", "HostnameVerifier") and
    this.hasStringSignature("verify(String, SSLSession)")
  }
}

/** Defines `HostnameVerifier.verity()` calls that is not wrapped in another `HostnameVerifier`. */
private class HostnameVerificationCall extends MethodAccess {
  HostnameVerificationCall() {
    this.getMethod() instanceof HostnameVerifierVerifyMethod and
    not this.getCaller() instanceof HostnameVerifierVerifyMethod
  }

  /** Holds if the result of the call is not used. */
  predicate isIgnored() {
    not exists(Expr expr, IfStmt ifStmt, MethodAccess ma |
      this = [expr.getAChildExpr(), ifStmt.getCondition(), ma.getAnArgument()]
    )
  }
}

from HostnameVerificationCall verification
where verification.isIgnored()
select verification, "Ignored result of hostname verification."
