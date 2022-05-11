/**
 * @name Server Side Template Injection
 * @description Untrusted input used as a template parameter can lead to remote code execution.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/server-side-template-injection
 * @tags security
 *       external/cwe/cwe-094
 */

import java
import TemplateInjection
import DataFlow::PathGraph

from TemplateInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Potential arbitrary code execution due to $@.",
  source.getNode(), "a template value loaded from a remote source."
