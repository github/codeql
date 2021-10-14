/**
 * @name Log Injection
 * @description Building log entries from user-controlled data is vulnerable to
 *              insertion of forged log entries by a malicious user.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/log-injection
 * @tags security
 *       external/cwe/cwe-117
 */

import python
import experimental.semmle.python.security.injection.LogInjection
import DataFlow::PathGraph

from LogInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to log entry.", source.getNode(),
  "User-provided value"
