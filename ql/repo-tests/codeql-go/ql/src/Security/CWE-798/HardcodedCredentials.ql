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
import semmle.go.security.SensitiveActions

/**
 * Holds if `sink` is used in a context that suggests it may hold sensitive data of
 * the given `type`.
 */
predicate isSensitive(DataFlow::Node sink, SensitiveExpr::Classification type) {
  exists(Write write, string name |
    write.getRhs() = sink and
    name = write.getLhs().getName() and
    // allow obvious test password variables
    not name.regexpMatch(HeuristicNames::notSensitive())
  |
    name.regexpMatch(HeuristicNames::maybeSensitive(type))
  )
}

from DataFlow::Node source, string message, DataFlow::Node sink, SensitiveExpr::Classification type
where
  exists(string val | val = source.getStringValue() and val != "" |
    isSensitive(sink, type) and
    DataFlow::localFlow(source, sink) and
    // allow obvious dummy/test values
    not PasswordHeuristics::isDummyPassword(val) and
    not sink.asExpr().(Ident).getName().regexpMatch(HeuristicNames::notSensitive())
  ) and
  message = "Hard-coded $@."
  or
  source
      .getStringValue()
      .regexpMatch("(?s)-+BEGIN\\b.*\\bPRIVATE KEY-+.+-+END\\b.*\\bPRIVATE KEY-+\n?") and
  (source.asExpr() instanceof StringLit or source.asExpr() instanceof AddExpr) and
  sink = source and
  type = SensitiveExpr::certificate() and
  message = "Hard-coded private key."
select sink, message, source, type.toString()
