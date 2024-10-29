/**
 * @name Hard-coded credentials
 * @description Hard-coding credentials in source code may enable an attacker
 *              to gain unauthorized access.
 * @kind problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision medium
 * @id go/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import go
import semmle.go.security.HardcodedCredentials
import semmle.go.security.SensitiveActions

/**
 * Holds if `sink` is used in a context that suggests it may hold sensitive data of
 * the given `type`.
 */
predicate isSensitive(DataFlow::Node sink, SensitiveExpr::Classification type) {
  exists(Write write, string name |
    pragma[only_bind_out](write).getRhs() = sink and
    name = pragma[only_bind_out](write).getLhs().getName() and
    // allow obvious test password variables
    not name.regexpMatch(HeuristicNames::notSensitive())
  |
    name.regexpMatch(HeuristicNames::maybeSensitive(type))
  )
}

predicate sensitiveAssignment(
  DataFlow::Node source, DataFlow::Node sink, SensitiveExpr::Classification type
) {
  exists(string val | val = source.getStringValue() and val != "" |
    DataFlow::localFlow(source, sink) and
    isSensitive(sink, type) and
    // allow obvious dummy/test values
    not PasswordHeuristics::isDummyPassword(val) and
    not sink.asExpr().(Ident).getName().regexpMatch(HeuristicNames::notSensitive())
  )
}

predicate hardcodedPrivateKey(DataFlow::Node node, SensitiveExpr::Classification type) {
  node.getStringValue()
      .regexpMatch("(?s)-+BEGIN\\b.*\\bPRIVATE KEY-+.+-+END\\b.*\\bPRIVATE KEY-+\n?") and
  type = SensitiveExpr::certificate()
}

from DataFlow::Node source, string message, DataFlow::Node sink, SensitiveExpr::Classification type
where
  sensitiveAssignment(source, sink, type) and
  message = "Hard-coded $@."
  or
  hardcodedPrivateKey(source, type) and
  source = sink and
  message = "Hard-coded private key."
  or
  HardcodedCredentials::Flow::flow(source, sink) and
  type = SensitiveExpr::secret() and
  message = "Hard-coded $@."
select sink, message, source, type.toString()
