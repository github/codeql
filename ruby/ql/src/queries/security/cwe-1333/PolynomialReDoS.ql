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

import codeql.ruby.security.regexp.PolynomialReDoSCustomizations::PolynomialReDoS as PR
import codeql.ruby.security.regexp.PolynomialReDoSQuery
import PolynomialReDoSFlow::PathGraph

from
  PolynomialReDoSFlow::PathNode source, PolynomialReDoSFlow::PathNode sink, PR::Sink sinkNode,
  PR::PolynomialBackTrackingTerm regexp
where
  PolynomialReDoSFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  regexp = sinkNode.getRegExp()
select sinkNode.getHighlight(), source, sink,
  "This $@ that depends on a $@ may run slow on strings " + regexp.getPrefixMessage() +
    "with many repetitions of '" + regexp.getPumpString() + "'.", regexp, "regular expression",
  source.getNode(), source.getNode().(PR::Source).describe()
