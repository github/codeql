/**
 * @name Template Object Injection
 * @description Instantiating a template using a user-controlled object is vulnerable to local file read and potential remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id js/template-object-injection
 * @tags security
 *       external/cwe/cwe-073
 *       external/cwe/cwe-094
 */

import javascript
import semmle.javascript.security.dataflow.TemplateObjectInjectionQuery
import DataFlow::DeduplicatePathGraph<TemplateObjectInjectionFlow::PathNode, TemplateObjectInjectionFlow::PathGraph>

from PathNode source, PathNode sink
where
  TemplateObjectInjectionFlow::flowPath(source.getAnOriginalPathNode(), sink.getAnOriginalPathNode())
select sink.getNode(), source, sink, "Template object depends on a $@.", source.getNode(),
  "user-provided value"
