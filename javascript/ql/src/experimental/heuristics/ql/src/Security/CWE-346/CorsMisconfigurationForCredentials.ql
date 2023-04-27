/**
 * @name CORS misconfiguration for credentials transfer with additional heuristic sources
 * @description Misconfiguration of CORS HTTP headers allows for leaks of secret credentials.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id js/cors-misconfiguration-for-credentials-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-346
 *       external/cwe/cwe-639
 *       external/cwe/cwe-942
 */

import javascript
import semmle.javascript.security.dataflow.CorsMisconfigurationForCredentialsQuery
import DataFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "$@ leak vulnerability due to a $@.",
  sink.getNode().(Sink).getCredentialsHeader(), "Credential", source.getNode(),
  "misconfigured CORS header value"
