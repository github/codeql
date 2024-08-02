/**
 * @name Second order command injection
 * @description Using user-controlled data as arguments to some commands, such as git clone,
 *              can allow arbitrary commands to be executed.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision high
 * @id js/second-order-command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import javascript
import semmle.javascript.security.dataflow.SecondOrderCommandInjectionQuery
import DataFlow::DeduplicatePathGraph<SecondOrderCommandInjectionFlow::PathNode, SecondOrderCommandInjectionFlow::PathGraph>

from PathNode source, PathNode sink, Sink sinkNode
where
  SecondOrderCommandInjectionFlow::flowPath(source.getAnOriginalPathNode(),
    sink.getAnOriginalPathNode()) and
  sinkNode = sink.getNode()
select sink.getNode(), source, sink,
  "Command line argument that depends on $@ can execute an arbitrary command if " +
    sinkNode.getVulnerableArgumentExample() + " is used with " + sinkNode.getCommand() + ".",
  source.getNode(), source.getNode().(Source).describe()
