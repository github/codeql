/**
 * @name Android missing certificate pinning
 * @description Network connections that do not use certificate pinning may allow attackers to eavesdrop on communications.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.9
 * @precision medium
 * @id java/android/missing-certificate-pinning-automodel
 * @tags security
 *       external/cwe/cwe-295
 *       ai-generated
 */

import java
import semmle.code.java.security.AndroidCertificatePinningQuery
private import semmle.code.java.AutomodelSinkTriageUtils

from DataFlow::Node node, string domain, string msg
where
  missingPinning(node, domain) and
  if domain = ""
  then msg = "(no explicitly trusted domains)"
  else msg = "(" + domain + " is not trusted by a pin)"
select node,
  "This network call does not implement certificate pinning. " + msg +
    getSinkModelQueryRepr(node.asExpr())
