/**
 * @name Expression language injection (Jexl)
 * @description Evaluation of a user-controlled Jexl expression
 *              may lead to arbitrary code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/jexl-expression-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import JexlInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, JexlInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Jexl injection from $@.", source.getNode(), "this user input"
