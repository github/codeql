/**
 * @name Type confusion through parameter tampering
 * @description Sanitizing an HTTP request parameter may be ineffective if the user controls its type.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id js/type-confusion-through-parameter-tampering
 * @tags security
 *       external/cwe/cwe-843
 */

import javascript
import semmle.javascript.security.dataflow.TypeConfusionThroughParameterTampering::TypeConfusionThroughParameterTampering
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential type confusion for $@.", source.getNode(),
  "HTTP request parameter"
