/**
 * @name Log entries created from user input
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id go/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import go
import semmle.go.security.LogInjection
import LogInjection::Flow::PathGraph

from LogInjection::Flow::PathNode source, LogInjection::Flow::PathNode sink
where LogInjection::Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "This log entry depends on a $@.", source.getNode(),
  "user-provided value"
