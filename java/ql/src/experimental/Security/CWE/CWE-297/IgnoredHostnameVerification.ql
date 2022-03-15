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
import semmle.code.java.security.Encryption

/** A `HostnameVerifier.verify()` call that is not wrapped in another `HostnameVerifier`. */
private class HostnameVerificationCall extends MethodAccess {
  HostnameVerificationCall() {
    this.getMethod() instanceof HostnameVerifierVerify and
    not this.getCaller() instanceof HostnameVerifierVerify
  }

  /** Holds if the result of the call is not used. */
  predicate isIgnored() { this = any(ExprStmt es).getExpr() }
}

from HostnameVerificationCall verification
where verification.isIgnored()
select verification, "Ignored result of hostname verification."
