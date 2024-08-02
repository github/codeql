/**
 * @name XML external entity expansion with additional heuristic sources
 * @description Parsing user input as an XML document with external
 *              entity expansion is vulnerable to XXE attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id js/xxe-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-827
 */

import javascript
import semmle.javascript.security.dataflow.XxeQuery
import XxeFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from XxeFlow::PathNode source, XxeFlow::PathNode sink
where XxeFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink,
  "XML parsing depends on a $@ without guarding against external entity expansion.",
  source.getNode(), "user-provided value"
