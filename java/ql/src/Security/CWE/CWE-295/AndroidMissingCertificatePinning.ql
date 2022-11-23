/**
 * @name Android Missing Certificate Pinning
 * @description Network communication should use certificate pinning.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/android/missing-certificate-pinning
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.security.AndroidCertificatePinningQuery

from DataFlow::Node node, string msg
where
  missingPinning(node) and
  if exists(string x | trustedDomain(x))
  then msg = "(untrusted domain)"
  else msg = "(no trusted domains)"
select node, "This network call does not implement certificate pinning. " + msg
