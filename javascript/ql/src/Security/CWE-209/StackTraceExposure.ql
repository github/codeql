/**
 * @name Information exposure through a stack trace
 * @description Propagating stack trace information to an external user can
 *              unintentionally reveal implementation details that are useful
 *              to an attacker for developing a subsequent exploit.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id js/stack-trace-exposure
 * @tags security
 *       external/cwe/cwe-209
 */

import javascript
import semmle.javascript.security.dataflow.StackTraceExposure::StackTraceExposure

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "Stack trace information from $@ may be exposed to an external user here.",
       source, "here"