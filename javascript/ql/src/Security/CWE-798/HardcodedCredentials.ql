/**
 * @name Hard-coded credentials
 * @description Hard-coding credentials in source code may enable an attacker
 *              to gain unauthorized access.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @id js/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import javascript
import semmle.javascript.security.dataflow.HardcodedCredentialsQuery
import HardcodedCredentials::PathGraph

bindingset[s]
predicate looksLikeATemplate(string s) { s.regexpMatch(".*((\\{\\{.*\\}\\})|(<.*>)|(\\(.*\\))).*") }

from HardcodedCredentials::PathNode source, HardcodedCredentials::PathNode sink, string value
where
  HardcodedCredentials::flowPath(source, sink) and
  // use source value in message if it's available
  if source.getNode().asExpr() instanceof ConstantString
  then
    exists(string val | val = source.getNode().getStringValue() |
      // exclude dummy passwords and templates
      not (
        sink.getNode().(Sink).(DefaultCredentialsSink).getKind() =
          ["password", "credentials", "token", "key"] and
        PasswordHeuristics::isDummyPassword(val)
        or
        sink.getNode().(Sink).getKind() = "authorization header" and
        PasswordHeuristics::isDummyAuthHeader(val)
        or
        looksLikeATemplate(val)
      ) and
      value = "The hard-coded value \"" + val + "\""
    )
  else value = "This hard-coded value"
select source.getNode(), source, sink, value + " is used as $@.", sink.getNode(),
  sink.getNode().(Sink).getKind()
