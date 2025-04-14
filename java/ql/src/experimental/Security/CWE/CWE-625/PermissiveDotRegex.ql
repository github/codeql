/**
 * @name URL matched by permissive `.` in a regular expression
 * @description URLs validated with a permissive `.` in regular expressions may be vulnerable
 *              to an authorization bypass.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/permissive-dot-regex
 * @tags security
 *       experimental
 *       external/cwe/cwe-625
 *       external/cwe/cwe-863
 */

import java
import semmle.code.java.dataflow.FlowSources
deprecated import MatchRegexFlow::PathGraph
deprecated import PermissiveDotRegexQuery

deprecated query predicate problems(
  DataFlow::Node sinkNode, MatchRegexFlow::PathNode source, MatchRegexFlow::PathNode sink,
  string message1, DataFlow::Node sourceNode, string message2
) {
  MatchRegexFlow::flowPath(source, sink) and
  sinkNode = sink.getNode() and
  message1 = "Potentially authentication bypass due to $@." and
  sourceNode = source.getNode() and
  message2 = "user-provided value"
}
