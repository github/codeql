/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @sub-severity high
 * @precision high
 * @id py/command-line-injection
 * @tags correctness
 *       security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import python
import semmle.python.security.dataflow.CommandInjectionQuery
import DataFlow::PathGraph

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a user-provided value"
