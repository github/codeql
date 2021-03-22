/**
 * @name Expression language injection (JEXL)
 * @description Evaluation of a user-controlled JEXL expression
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
select sink.getNode(), source, sink, "JEXL injection from $@.", source.getNode(), "this user input"
