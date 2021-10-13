/**
 * @name Potentially unsafe quoting
 * @description If a quoted string literal is constructed from data that may itself contain quotes,
 *              the embedded data could (accidentally or intentionally) change the structure of
 *              the overall string.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @id go/unsafe-quoting
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-089
 *       external/cwe/cwe-094
 */

import go
import semmle.go.security.StringBreak
import DataFlow::PathGraph

from StringBreak::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "If this $@ contains a " + cfg.getQuote().getType() + " quote, it could break out of " +
    "the enclosing quotes.", source.getNode(), "JSON value"
