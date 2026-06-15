/**
 * @name Log injection with additional heuristic sources
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id js/log-injection-more-sources
 * @tags experimental
 *       security
 *       external/cwe/cwe-117
 */

import javascript
import semmle.javascript.security.dataflow.LogInjectionQuery
import semmle.javascript.heuristics.AdditionalSources
import LogInjectionFlow::PathGraph

from LogInjectionFlow::PathNode source, LogInjectionFlow::PathNode sink
where LogInjectionFlow::flowPath(source, sink) and source.getNode() instanceof HeuristicSource
select sink.getNode(), source, sink, "Log entry depends on a $@.", source.getNode(),
  "user-provided value"
