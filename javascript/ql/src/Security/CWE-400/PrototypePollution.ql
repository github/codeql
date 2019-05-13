/**
 * @name Prototype Pollution
 * @description Recursively merging a user-controlled object into another object
 *              can allow an attacker to modify the built-in Object prototype. 
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id js/prototype-pollution
 * @tags security
 *       external/cwe/cwe-250
 *       external/cwe/cwe-400
 */

import javascript
import semmle.javascript.security.dataflow.PrototypePollution::PrototypePollution
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Prototype pollution caused by merging a user-controlled value from $@.", source, "here"
