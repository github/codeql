/**
 * @name Prototype-polluting merge call
 * @description Recursively merging a user-controlled object into another object
 *              can allow an attacker to modify the built-in Object prototype,
 *              and possibly escalate to remote code execution or cross-site scripting.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.1
 * @precision high
 * @id js/prototype-pollution
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-079
 *       external/cwe/cwe-094
 *       external/cwe/cwe-400
 *       external/cwe/cwe-471
 *       external/cwe/cwe-915
 */

import javascript
import semmle.javascript.security.dataflow.PrototypePollutionQuery
import DataFlow::DeduplicatePathGraph<PrototypePollutionFlow::PathNode, PrototypePollutionFlow::PathGraph>

from PathNode source, PathNode sink, string moduleName, Locatable dependencyLoc
where
  PrototypePollutionFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode()) and
  sink.getNode().(Sink).dependencyInfo(moduleName, dependencyLoc)
select sink.getNode(), source, sink,
  "Prototype pollution caused by merging a $@ using a vulnerable version of $@.", source,
  "user-controlled value", dependencyLoc, moduleName
