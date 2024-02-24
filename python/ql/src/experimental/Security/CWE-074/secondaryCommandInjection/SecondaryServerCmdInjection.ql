/**
 * @name RCE with user provided command with paramiko ssh client
 * @description user provided command can lead to execute code on a external server that can be belong to other users or admins
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @precision high
 * @id py/paramiko-command-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-074
 */

import python
import experimental.semmle.python.security.SecondaryServerCmdInjection
import ParamikoFlow::PathGraph

from ParamikoFlow::PathNode source, ParamikoFlow::PathNode sink
where ParamikoFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This code execution depends on a $@.", source.getNode(),
  "a user-provided value"
