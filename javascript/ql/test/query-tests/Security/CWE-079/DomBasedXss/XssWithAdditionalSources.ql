/**
 * @name Client-side cross-site scripting
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/xss-additional-sources-dom-test
 * @tags security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery
import DataFlow::DeduplicatePathGraph<DomBasedXssFlow::PathNode, DomBasedXssFlow::PathGraph>
import semmle.javascript.heuristics.AdditionalSources

from PathNode source, PathNode sink
where
  DomBasedXssFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode()) and
  source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink,
  sink.getNode().(Sink).getVulnerabilityKind() + " vulnerability due to $@.", source.getNode(),
  "user-provided value"
