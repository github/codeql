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
import DataFlow::PathGraph
import semmle.javascript.filters.ClassifyFiles

bindingset[s]
predicate looksLikeATemplate(string s) { s.regexpMatch(".*((\\{\\{.*\\}\\})|(<.*>)|(\\(.*\\))).*") }

predicate updateMessageWithSourceValue(string value, DataFlow::Node source, DataFlow::Node sink) {
  exists(string val | val = source.getStringValue() |
    // exclude dummy passwords and templates
    not (
      sink.(Sink).(DefaultCredentialsSink).getKind() = ["password", "credentials", "token", "key"] and
      PasswordHeuristics::isDummyPassword(val)
      or
      sink.(Sink).getKind() = "authorization header" and
      PasswordHeuristics::isDummyAuthHeader(val)
      or
      looksLikeATemplate(val)
    ) and
    value = "The hard-coded value \"" + val + "\""
  )
}

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, string value
where
  cfg.hasFlowPath(source, sink) and
  // sink kind is "jwt key" and source is constant string
  if
    sink.getNode().(Sink).(DefaultCredentialsSink).getKind() = "jwt key" and
    // use source value in message if it's available
    source.getNode().asExpr() instanceof ConstantString
  then
    not isTestFile(sink.getNode().getFile()) and
    updateMessageWithSourceValue(value, source.getNode(), sink.getNode())
  else
    // sink kind is "jwt key" and source is not constant string
    if
      sink.getNode().(Sink).(DefaultCredentialsSink).getKind() = "jwt key" and
      not source.getNode().asExpr() instanceof ConstantString
    then not isTestFile(sink.getNode().getFile()) and value = "This hard-coded value"
    else
      // sink kind is not "jwt key" and source is  constant string
      if
        not sink.getNode().(Sink).(DefaultCredentialsSink).getKind() = "jwt key" and
        source.getNode().asExpr() instanceof ConstantString
      then updateMessageWithSourceValue(value, source.getNode(), sink.getNode())
      else value = "This hard-coded value"
select source.getNode(), source, sink, value + " is used as $@.", sink.getNode(),
  sink.getNode().(Sink).getKind()
