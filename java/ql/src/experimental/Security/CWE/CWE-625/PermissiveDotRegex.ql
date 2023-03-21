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
 *       external/cwe-625
 *       external/cwe-863
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph
import PermissiveDotRegexQuery

from DataFlow::PathNode source, DataFlow::PathNode sink, MatchRegexConfiguration conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potentially authentication bypass due to $@.",
  source.getNode(), "user-provided value"
