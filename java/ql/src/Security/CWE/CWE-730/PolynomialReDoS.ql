/**
 * @name Polynomial regular expression used on uncontrolled data
 * @description A regular expression that can require polynomial time
 *              to match may be vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/polynomial-redos
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import java
import semmle.code.java.security.performance.PolynomialReDosQuery
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, PolynomialBackTrackingTerm regexp
where hasPolynomialReDosResult(source, sink, regexp)
select sink, source, sink,
  "This $@ that depends on $@ may run slow on strings " + regexp.getPrefixMessage() +
    "with many repetitions of '" + regexp.getPumpString() + "'.", regexp, "regular expression",
  source.getNode(), "a user-provided value"
