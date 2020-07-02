/**
 * @name Expression language injection (MVEL)
 * @description Evaluation of a user-controlled MVEL expression
 *              may lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/mvel-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import MvelInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, MvelInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "MVEL injection from $@.", source.getNode(), "this user input"
