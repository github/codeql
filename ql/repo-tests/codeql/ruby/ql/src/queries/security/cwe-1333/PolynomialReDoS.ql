/**
 * @name Polynomial regular expression used on uncontrolled data
 * @description A regular expression that can require polynomial time
 *              to match may be vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id rb/polynomial-redos
 * @tags security
 *       external/cwe/cwe-1333
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import DataFlow::PathGraph
import codeql.ruby.DataFlow
import codeql.ruby.security.performance.PolynomialReDoSQuery
import codeql.ruby.security.performance.SuperlinearBackTracking

from
  PolynomialReDoS::Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink,
  PolynomialReDoS::Sink sinkNode, PolynomialBackTrackingTerm regexp
where
  config.hasFlowPath(source, sink) and
  sinkNode = sink.getNode() and
  regexp = sinkNode.getRegExp()
select sinkNode.getHighlight(), source, sink,
  "This $@ that depends on $@ may run slow on strings " + regexp.getPrefixMessage() +
    "with many repetitions of '" + regexp.getPumpString() + "'.", regexp, "regular expression",
  source.getNode(), "a user-provided value"
