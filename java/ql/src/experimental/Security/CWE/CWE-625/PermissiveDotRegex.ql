/**
 * @name URL matched by permissive `.` in the regular expression
 * @description URL validated with permissive `.` in regex  are possibly vulnerable
 *              to an authorization bypass.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id java/permissive-dot-regex
 * @tags security
 *       external/cwe-625
 *       external/cwe-863
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph
import PermissiveDotRegexQuery

from DataFlow::PathNode source, DataFlow::PathNode sink, MatchRegexConfiguration conf
where
  conf.hasFlowPath(source, sink) and
  exists(MethodAccess ma | any(PermissiveDotRegexConfig conf2).hasFlowToExpr(ma.getArgument(0)) |
    // input.matches(regexPattern)
    ma.getMethod() instanceof StringMatchMethod and
    ma.getQualifier() = sink.getNode().asExpr()
    or
    // p = Pattern.compile(regexPattern); p.matcher(input)
    ma.getMethod() instanceof PatternCompileMethod and
    exists(MethodAccess pma |
      pma.getMethod() instanceof PatternMatcherMethod and
      sink.getNode().asExpr() = pma.getArgument(0) and
      DataFlow::localExprFlow(ma, pma.getQualifier())
    )
    or
    // p = Pattern.matches(regexPattern, input)
    ma.getMethod() instanceof PatternMatchMethod and
    sink.getNode().asExpr() = ma.getArgument(1)
  )
select sink.getNode(), source, sink, "Potentially authentication bypass due to $@.",
  source.getNode(), "user-provided value"
