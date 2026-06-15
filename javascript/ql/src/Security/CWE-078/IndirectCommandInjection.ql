/**
 * @name Indirect uncontrolled command line
 * @description Forwarding command-line arguments to a child process
 *              executed within a shell may indirectly introduce
 *              command-line injection vulnerabilities.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 6.3
 * @precision medium
 * @id js/indirect-command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import semmle.javascript.security.dataflow.IndirectCommandInjectionQuery
import IndirectCommandInjectionFlow::PathGraph

from
  IndirectCommandInjectionFlow::PathNode source, IndirectCommandInjectionFlow::PathNode sink,
  DataFlow::Node highlight
where
  IndirectCommandInjectionFlow::flowPath(source, sink) and
  if IndirectCommandInjectionConfig::isSinkWithHighlight(sink.getNode(), _)
  then IndirectCommandInjectionConfig::isSinkWithHighlight(sink.getNode(), highlight)
  else highlight = sink.getNode()
select highlight, source, sink, "This command depends on an unsanitized $@.", source.getNode(),
  source.getNode().(Source).describe()
