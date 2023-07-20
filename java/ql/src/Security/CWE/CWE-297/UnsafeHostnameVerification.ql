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
import semmle.code.java.security.UnsafeHostnameVerificationQuery
import TrustAllHostnameVerifierFlow::PathGraph

from
  TrustAllHostnameVerifierFlow::PathNode source, TrustAllHostnameVerifierFlow::PathNode sink,
  RefType verifier
where
  TrustAllHostnameVerifierFlow::flowPath(source, sink) and
  not isNodeGuardedByFlag(sink.getNode()) and
  verifier = source.getNode().asExpr().(ClassInstanceExpr).getConstructedType()
select sink, source, sink,
  "The $@ defined by $@ always accepts any certificate, even if the hostname does not match.",
  source, "hostname verifier", verifier, "this type"
