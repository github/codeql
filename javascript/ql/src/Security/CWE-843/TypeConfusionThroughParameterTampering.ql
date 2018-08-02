/**
 * @name Type confusion through parameter tampering
 * @description Sanitizing an HTTP request parameter may be ineffective if the user controls its type.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id js/type-confusion-through-parameter-tampering
 * @tags security
 *       external/cwe/cwe-843
 */

import javascript
import semmle.javascript.security.dataflow.TypeConfusionThroughParameterTampering::TypeConfusionThroughParameterTampering

from Configuration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink, "Potential type confusion for $@.", source, "HTTP request parameter"