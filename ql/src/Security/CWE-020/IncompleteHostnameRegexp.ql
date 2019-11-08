/**
 * @name Incomplete regular expression for hostnames
 * @description Matching a URL or hostname against a regular expression that contains an unescaped
 *              dot as part of the hostname might match more hostnames than expected.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id go/incomplete-hostname-regexp
 * @tags correctness
 *       security
 *       external/cwe/cwe-20
 */

import go
import DataFlow::PathGraph

/**
 * Holds if `pattern` is a regular expression pattern for URLs with a host matched by `hostPart`,
 * and `pattern` contains a subtle mistake that allows it to match unexpected hosts.
 */
bindingset[pattern]
predicate isIncompleteHostNameRegexpPattern(string pattern, string hostPart) {
  hostPart = pattern
        .regexpCapture("(?i).*" +
            // an unescaped single `.`
            "(?<!\\\\)[.]" +
            // immediately followed by a sequence of subdomains, perhaps with some regex characters mixed in,
            // followed by a known TLD
            "([():|?a-z0-9-]+(\\\\)?[.]" + commonTLD() + ")" + ".*", 1)
}

class Config extends DataFlow::Configuration {
  Config() { this = "IncompleteHostNameRegexp::Config" }

  predicate isSource(DataFlow::Node source, string hostPart) {
    exists(Expr e |
      e = source.asExpr() and
      isIncompleteHostNameRegexpPattern(e.getStringValue(), hostPart)
    |
      e instanceof StringLit
      or
      e instanceof AddExpr and
      not isIncompleteHostNameRegexpPattern(e.(AddExpr).getAnOperand().getStringValue(), _)
    )
  }

  override predicate isSource(DataFlow::Node source) { isSource(source, _) }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexpPattern }
}

from Config c, DataFlow::PathNode source, DataFlow::PathNode sink, string hostPart
where c.hasFlowPath(source, sink) and c.isSource(source.getNode(), hostPart)
select source, source, sink,
  "This regular expression has an unescaped dot before '" + hostPart + "', " +
    "so it might match more hosts than expected when used $@.", sink, "here"
