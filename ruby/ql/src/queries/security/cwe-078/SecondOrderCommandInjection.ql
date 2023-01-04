/**
 * @name Second order command injection
 * @description Using user-controlled data as arguments to some commands, such as git clone,
 *              can allow arbitrary commands to be executed.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id rb/second-order-command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import ruby
import DataFlow::PathGraph
import codeql.ruby.security.SecondOrderCommandInjectionQuery

from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink, Sink sinkNode
where cfg.hasFlowPath(source, sink) and sinkNode = sink.getNode()
select sink.getNode(), source, sink,
  "'" + sinkNode.getCommand() +
    "' arguments that depends on $@, and are used in a $@, can execute an arbitrary command if " +
    sinkNode.getVulnerableArgumentExample() + " is used with " + sinkNode.getCommand() + ".",
  source.getNode(), source.getNode().(Source).describe(), sinkNode.getCommandExecution(),
  "shell command execution"
