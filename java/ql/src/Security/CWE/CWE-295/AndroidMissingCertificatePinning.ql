/**
 * @name Android Missing Certificate Pinning
 * @description Network communication should use certificate pinning.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id java/android/missing-certificate-pinning
 * @tags security
 *       external/cwe/cwe-295
 */

import java
import semmle.code.java.security.AndroidCertificatePinningQuery

from DataFlow::Node node, string domain, string msg
where
  missingPinning(node, domain) and
  if domain = ""
  then msg = "(no explicitly trusted domains)"
  else msg = "(" + domain + " is not trusted by a pin)"
select node, "This network call does not implement certificate pinning. " + msg
