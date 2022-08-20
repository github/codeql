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
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to log entry.", source.getNode(),
  "User-provided value"
