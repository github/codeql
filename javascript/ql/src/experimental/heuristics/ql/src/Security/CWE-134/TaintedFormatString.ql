/**
 * @name Use of externally-controlled format string with additional heuristic sources
 * @description Using external input in format strings can lead to garbled output.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.3
 * @precision high
 * @id js/tainted-format-string-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-134
 */

import javascript
import semmle.javascript.security.dataflow.TaintedFormatStringQuery
import TaintedFormatStringFlow::PathGraph
import semmle.javascript.heuristics.AdditionalSources

from TaintedFormatStringFlow::PathNode source, TaintedFormatStringFlow::PathNode sink
where
  TaintedFormatStringFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "Format string depends on a $@.", source.getNode(),
  "user-provided value"
