/**
 * @name Polynomial regular expression used on uncontrolled data
 * @description A regular expression that can require polynomial time
 *              to match may be vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id cpp/polynomial-redos
 * @tags security
 *       external/cwe/cwe-1333
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import cpp
import semmle.code.cpp.security.regexp.PolynomialReDoSQuery
import PolynomialRedosFlow::PathGraph

from
  PolynomialRedosFlow::PathNode source, PolynomialRedosFlow::PathNode sink,
  SuperlinearBackTracking::PolynomialBackTrackingTerm regexp
where
  PolynomialRedosFlow::flowPath(source, sink) and
  regexp.getRootTerm() = sink.getNode().(PolynomialRedosSink).getRegExp()
select sink, source, sink,
  "This $@ that depends on a $@ may run slow on strings " + regexp.getPrefixMessage() +
    "with many repetitions of '" + regexp.getPumpString() + "'.", regexp, "regular expression",
  source.getNode(), "user-provided value"
