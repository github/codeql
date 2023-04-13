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
import MatchRegexFlow::PathGraph
import PermissiveDotRegexQuery

from MatchRegexFlow::PathNode source, MatchRegexFlow::PathNode sink
where MatchRegexFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potentially authentication bypass due to $@.",
  source.getNode(), "user-provided value"
