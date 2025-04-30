/**
 * @name Remote property injection with additional heuristic sources
 * @description Allowing writes to arbitrary properties of an object may lead to
 *              denial-of-service attacks.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id js/remote-property-injection-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-250
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.dataflow.RemotePropertyInjectionQuery
import RemotePropertyInjectionFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from RemotePropertyInjectionFlow::PathNode source, RemotePropertyInjectionFlow::PathNode sink
where
  RemotePropertyInjectionFlow::flowPath(source, sink) and
  source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, sink.getNode().(Sink).getMessage() + " depends on a $@.",
  source.getNode(), "user-provided value"
