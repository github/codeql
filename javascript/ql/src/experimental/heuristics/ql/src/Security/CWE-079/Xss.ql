/**
 * @name Client-side cross-site scripting with additional heuristic sources
 * @description Writing user input directly to the DOM allows for
 *              a cross-site scripting vulnerability.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id js/xss-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery
import semmle.javascript.heuristics.AdditionalSources
import DomBasedXssFlow::PathGraph

from DomBasedXssFlow::PathNode source, DomBasedXssFlow::PathNode sink
where DomBasedXssFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink,
  sink.getNode().(Sink).getVulnerabilityKind() + " vulnerability due to $@.", source.getNode(),
  "user-provided value"
