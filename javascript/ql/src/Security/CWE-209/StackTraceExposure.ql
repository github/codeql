/**
 * @name Information exposure through a stack trace
 * @description Propagating stack trace information to an external user can
 *              unintentionally reveal implementation details that are useful
 *              to an attacker for developing a subsequent exploit.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 5.4
 * @precision very-high
 * @id js/stack-trace-exposure
 * @tags security
 *       external/cwe/cwe-209
 *       external/cwe/cwe-497
 */

import javascript
import semmle.javascript.security.dataflow.StackTraceExposureQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This information exposed to the user depends on $@.",
  source.getNode(), "stack trace information"
