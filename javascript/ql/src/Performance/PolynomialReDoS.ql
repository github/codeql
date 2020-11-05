/**
 * @name Polynomial regular expression used on uncontrolled data
 * @description A regular expression that can require polynomial time
 *              to match user-provided values may be
 *              vulnerable to denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/polynomial-redos
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.performance.PolynomialReDoS::PolynomialReDoS
import semmle.javascript.security.performance.SuperlinearBackTracking
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where
  cfg.hasFlowPath(source, sink) and
  not (
    source.getNode().(Source).getKind() = "url" and
    sink.getNode().(Sink).getRegExp().(PolynomialBackTrackingTerm).isAtEndLine()
  )
select sink.getNode(), source, sink, "This expensive $@ use depends on $@.",
  sink.getNode().(Sink).getRegExp(), "regular expression", source.getNode(), "a user-provided value"
