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
import DataFlow::PathGraph
import semmle.javascript.security.dataflow.IndirectCommandInjectionQuery

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, DataFlow::Node highlight
where
  cfg.hasFlowPath(source, sink) and
  if cfg.isSinkWithHighlight(sink.getNode(), _)
  then cfg.isSinkWithHighlight(sink.getNode(), highlight)
  else highlight = sink.getNode()
select highlight, source, sink, "This command depends on an unsanitized $@.", source.getNode(),
  source.getNode().(Source).describe()
