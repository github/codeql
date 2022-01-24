/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id rb/command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import ruby
import codeql.ruby.security.CommandInjectionQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink, Source sourceNode
where
  config.hasFlowPath(source, sink) and
  sourceNode = source.getNode()
select sink.getNode(), source, sink, "This command depends on $@.", sourceNode,
  sourceNode.getSourceType()
