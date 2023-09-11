/**
 * @name Log Injection
 * @description Building log entries from user-controlled data is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id py/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import python
import semmle.python.security.dataflow.LogInjectionQuery
import LogInjectionFlow::PathGraph

from LogInjectionFlow::PathNode source, LogInjectionFlow::PathNode sink
where LogInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This log entry depends on a $@.", source.getNode(),
  "user-provided value"
