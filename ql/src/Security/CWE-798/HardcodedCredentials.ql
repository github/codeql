/**
 * @name Hard-coded credentials
 * @description Hard-coding credentials in source code may enable an attacker
 *              to gain unauthorized access.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id go/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import go

/**
 * Holds if `sink` is used in a context that suggests it may hold sensitive data of
 * the given `type`.
 */
predicate isSensitive(DataFlow::Node sink, string type) {
  exists(Write write, string name |
    write.getRhs() = sink and
    name = write.getLhs().getName() and
    // whitelist obvious test password variables
    not name.regexpMatch("(?i)test.*")
  |
    name.regexpMatch("(?i)_*secret") and
    type = "secret"
    or
    name.regexpMatch("(?i)_*(secret|access|private|rsa|aes)_*key") and
    type = "key"
    or
    name.regexpMatch("(?i)_*(encrypted|old|new)?_*pass(wd|word|code|phrase)_*(chars|value)?") and
    type = "password"
  )
}

from DataFlow::Node source, string message, DataFlow::Node sink, string type
where
  exists(string val | val = source.getStringValue() and val != "" |
    isSensitive(sink, type) and
    DataFlow::localFlow(source, sink) and
    // whitelist obvious dummy/test values
    not val.regexpMatch("(?i)test|password|secret|--- redacted ---") and
    not sink.asExpr().(Ident).getName().regexpMatch("(?i)test.*")
  ) and
  message = "Hard-coded $@."
  or
  source
      .getStringValue()
      .regexpMatch("(?s)-+BEGIN\\b.*\\bPRIVATE KEY-+.+-+END\\b.*\\bPRIVATE KEY-+\n?") and
  (source.asExpr() instanceof StringLit or source.asExpr() instanceof AddExpr) and
  sink = source and
  type = "" and
  message = "Hard-coded private key."
select sink, message, source, type
