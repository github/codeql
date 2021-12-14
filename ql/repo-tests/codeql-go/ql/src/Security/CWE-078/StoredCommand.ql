/**
 * @name Command built from stored data
 * @description Building a system command from stored data that is user-controlled
 *              can lead to execution of malicious code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision low
 * @id go/stored-command
 * @tags security
 *       external/cwe/cwe-078
 */

import go
import semmle.go.security.StoredCommand
import DataFlow::PathGraph

from StoredCommand::Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on $@.", source.getNode(),
  "a stored value"
