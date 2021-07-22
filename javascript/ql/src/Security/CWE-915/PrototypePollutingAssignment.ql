/**
 * @name Prototype-polluting assignment
 * @description Modifying an object obtained via a user-controlled property name may
 *              lead to accidental mutation of the built-in Object prototype,
 *              and possibly escalate to remote code execution or cross-site scripting.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 3.6
 * @precision high
 * @id js/prototype-polluting-assignment
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-079
 *       external/cwe/cwe-094
 *       external/cwe/cwe-400
 *       external/cwe/cwe-915
 */

import javascript
import semmle.javascript.security.dataflow.PrototypePollutingAssignment::PrototypePollutingAssignment
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink, source, sink,
  "This assignment may alter Object.prototype if a malicious '__proto__' string is injected from $@.",
  source.getNode(), "here"
