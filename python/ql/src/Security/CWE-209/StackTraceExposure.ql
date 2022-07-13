/**
 * @name Information exposure through an exception
 * @description Leaking information about an exception, such as messages and stack traces, to an
 *              external user can expose implementation details that are useful to an attacker for
 *              developing a subsequent exploit.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 5.4
 * @precision high
 * @id py/stack-trace-exposure
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import python
import semmle.python.security.dataflow.StackTraceExposureQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ may be exposed to an external user", source.getNode(),
  "Error information"
