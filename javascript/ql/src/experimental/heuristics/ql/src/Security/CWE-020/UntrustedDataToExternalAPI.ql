/**
 * @name Untrusted data passed to external API with additional heuristic sources
 * @description Data provided remotely is used in this external API without sanitization, which could be a security risk.
 * @id js/untrusted-data-to-external-api-more-sources
 * @kind path-problem
 * @precision low
 * @problem.severity error
 * @security-severity 7.8
 * @tags experimental
 *       security external/cwe/cwe-20
 */

import javascript
import semmle.javascript.security.dataflow.ExternalAPIUsedWithUntrustedDataQuery
import DataFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink, source, sink,
  "Call to " + sink.getNode().(Sink).getApiName() + " with untrusted data from $@.", source,
  source.toString()
