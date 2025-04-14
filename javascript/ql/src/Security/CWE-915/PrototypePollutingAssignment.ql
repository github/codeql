/**
 * @name Prototype-polluting assignment
 * @description Modifying an object obtained via a user-controlled property name may
 *              lead to accidental mutation of the built-in Object prototype,
 *              and possibly escalate to remote code execution or cross-site scripting.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.1
 * @precision high
 * @id js/prototype-polluting-assignment
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-079
 *       external/cwe/cwe-094
 *       external/cwe/cwe-400
 *       external/cwe/cwe-471
 *       external/cwe/cwe-915
 */

import javascript
import semmle.javascript.security.dataflow.PrototypePollutingAssignmentQuery
import PrototypePollutingAssignmentFlow::PathGraph

from
  PrototypePollutingAssignmentFlow::PathNode source, PrototypePollutingAssignmentFlow::PathNode sink
where
  PrototypePollutingAssignmentFlow::flowPath(source, sink) and
  not isIgnoredLibraryFlow(source.getNode(), sink.getNode())
select sink, source, sink,
  "This assignment may alter Object.prototype if a malicious '__proto__' string is injected from $@.",
  source.getNode(), source.getNode().(Source).describe()
