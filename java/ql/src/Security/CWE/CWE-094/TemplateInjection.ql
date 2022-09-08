/**
 * @name Server-side template injection
 * @description Untrusted input interpreted as a template can lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/server-side-template-injection
 * @tags security
 *       external/cwe/cwe-1336
 *       external/cwe/cwe-094
 */

import java
import semmle.code.java.security.TemplateInjectionQuery
import DataFlow::PathGraph

from TemplateInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential arbitrary code execution due to $@.",
  source.getNode(), "a template value loaded from a remote source."
