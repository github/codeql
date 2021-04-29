/**
 * @name Injection in Mozilla Rhino JavaScript Engine
 * @description Evaluation of a user-controlled JavaScript or Java expression in Rhino
 *              JavaScript Engine may lead to remote code execution.
 * @kind path-problem
 * @id java/rhino-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import RhinoInjection
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, RhinoInjectionConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Rhino injection from $@.", source.getNode(), " user input"
