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

import ConfigurationInst::PathGraph
import codeql.ruby.DataFlow
import codeql.ruby.security.regexp.PolynomialReDoSQuery

from
  ConfigurationInst::PathNode source, ConfigurationInst::PathNode sink,
  PolynomialReDoS::Sink sinkNode, PolynomialReDoS::PolynomialBackTrackingTerm regexp
where
  ConfigurationInst::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  regexp = sinkNode.getRegExp()
select sinkNode.getHighlight(), source, sink,
  "This $@ that depends on a $@ may run slow on strings " + regexp.getPrefixMessage() +
    "with many repetitions of '" + regexp.getPumpString() + "'.", regexp, "regular expression",
  source.getNode(), source.getNode().(PolynomialReDoS::Source).describe()
