/**
 * @name Server Side Template Injection
 * @description Using user-controlled data to create a template can cause security issues.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id py/template-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-074
 */

import python
import TemplateInjectionQuery
import TemplateInjectionFlow::PathGraph

from TemplateInjectionFlow::PathNode source, TemplateInjectionFlow::PathNode sink
where TemplateInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This Template depends on $@.", source.getNode(),
  "user-provided value"
