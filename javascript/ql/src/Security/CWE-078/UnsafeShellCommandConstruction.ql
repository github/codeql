/**
 * @name Unsafe shell command constructed from library input
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 6.3
 * @precision high
 * @id js/shell-command-constructed-from-input
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import semmle.javascript.security.dataflow.UnsafeShellCommandConstructionQuery
import DataFlow::PathGraph

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Sink sinkNode
where cfg.hasFlowPath(source, sink) and sinkNode = sink.getNode()
select sinkNode.getAlertLocation(), source, sink,
  "This " + sinkNode.getSinkType() + " which depends on $@ is later used in a $@.",
  source.getNode(), "library input", sinkNode.getCommandExecution(), "shell command"
