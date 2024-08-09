/**
 * @name Secret exfiltration
 * @description Secrets may be exfiltrated by an attacker who can control the data sent to an external service.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.0
 * @precision high
 * @id actions/secret-exfiltration
 * @tags actions
 *       security
 *       experimental
 *       external/cwe/cwe-200
 */

import actions
import codeql.actions.security.SecretExfiltrationQuery
import SecretExfiltrationFlow::PathGraph

from SecretExfiltrationFlow::PathNode source, SecretExfiltrationFlow::PathNode sink
where SecretExfiltrationFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Potential secret exfiltration in $@, which may be be leaked to an attacker-controlled resource.",
  sink, sink.getNode().asExpr().(Expression).getRawExpression()
