/**
 * @name Log entries created from user input
 * @description Building log entries from user-controlled sources is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id cs/log-forging
 * @tags security
 *       external/cwe/cwe-117
 */

import csharp
import semmle.code.csharp.security.dataflow.LogForgingQuery
import LogForging::PathGraph

from LogForging::PathNode source, LogForging::PathNode sink
where LogForging::flowPath(source, sink)
select sink.getNode(), source, sink, "This log entry depends on a $@.", source.getNode(),
  "user-provided value"
