/**
 * @name Polynomial regular expression used on uncontrolled data
 * @description A regular expression that can require polynomial time
 *              to match may be vulnerable to denial-of-service attacks.
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

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Sink sinkNode
where
  cfg.hasFlowPath(source, sink) and
  sinkNode = sink.getNode() and
  not (
    source.getNode().(Source).getKind() = "url" and
    sinkNode.getRegExp().(PolynomialBackTrackingTerm).isAtEndLine()
  )
select sinkNode.getHighlight(), source, sink, "This expensive $@ use depends on $@.",
  sinkNode.getRegExp(), "regular expression", source.getNode(), source.getNode().(Source).describe()
