/**
 * @name Hard-coded credentials
 * @description Hard-coding credentials in source code may enable an attacker
 *              to gain unauthorized access.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import javascript
private import semmle.javascript.security.dataflow.HardcodedCredentials::HardcodedCredentials
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string value
where
  cfg.hasFlowPath(source, sink) and
  // use source value in message if it's available
  if source.getNode().asExpr() instanceof ConstantString
  then
    exists(string val | val = source.getNode().getStringValue() |
      // exclude dummy passwords
      not (
        sink.getNode().(Sink).(DefaultCredentialsSink).getKind() = "password" and
        PasswordHeuristics::isDummyPassword(val)
      ) and
      value = "The hard-coded value \"" + val + "\""
    )
  else value = "This hard-coded value"
select source.getNode(), source, sink, value + " is used as $@.", sink.getNode(),
  sink.getNode().(Sink).getKind()
