/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id js/code-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-079
 *       external/cwe/cwe-116
 */

import javascript
import semmle.javascript.security.dataflow.CodeInjectionQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "$@ flows to " + sink.getNode().(Sink).getMessageSuffix() + ".", source.getNode(),
  "User-provided value"
