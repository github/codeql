/**
 * @name Hard-coded credentials
 * @description Hard-coding credentials in source code may enable an attacker
 *              to gain unauthorized access.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision low
 * @id go/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import go
import semmle.go.security.HardcodedCredentials
import semmle.go.security.SensitiveActions

from DataFlow::Node source, string message, DataFlow::Node sink, SensitiveExpr::Classification type
where
  HardcodedCredentials::sensitiveAssignment(source, sink, type) and
  message = "Hard-coded $@."
  or
  HardcodedCredentials::hardcodedPrivateKey(source, type) and
  source = sink and
  message = "Hard-coded private key."
  or
  HardcodedCredentials::Flow::flow(source, sink) and
  type = SensitiveExpr::secret() and
  message = "Hard-coded $@."
select sink, message, source, type.toString()
