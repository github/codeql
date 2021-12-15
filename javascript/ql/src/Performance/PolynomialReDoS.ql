/**
 * @name Polynomial regular expression used on uncontrolled data
 * @description A regular expression that can require polynomial time
 *              to match may be vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/polynomial-redos
 * @tags security
 *       external/cwe/cwe-1333
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.performance.PolynomialReDoS::PolynomialReDoS
import semmle.javascript.security.performance.SuperlinearBackTracking
import DataFlow::PathGraph

from
  Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Sink sinkNode,
  PolynomialBackTrackingTerm regexp
where
  cfg.hasFlowPath(source, sink) and
  sinkNode = sink.getNode() and
  regexp = sinkNode.getRegExp() and
  not (
    source.getNode().(Source).getKind() = "url" and
    regexp.isAtEndLine()
  )
select sinkNode.getHighlight(), source, sink,
  "This $@ that depends on $@ may run slow on strings " + regexp.getPrefixMessage() +
    "with many repetitions of '" + regexp.getPumpString() + "'.", regexp, "regular expression",
  source.getNode(), source.getNode().(Source).describe()
