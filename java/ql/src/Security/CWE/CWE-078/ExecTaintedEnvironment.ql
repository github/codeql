/**
 * @name ExecTaintedEnvironment.ql
 * @description Using tainted data in a call to exec() may allow an attacker to execute arbitrary commands.
 * @problem.severity error
 * @kind path-problem
 * @precision medium
 * @id java/exec-tainted-environment
 * @tags security
 *     external/cwe/cwe-078
 *    external/cwe/cwe-088
 */

import java
import semmle.code.java.security.TaintedEnvironmentVariableQuery
import ExecTaintedEnvironmentFlow::PathGraph

from ExecTaintedEnvironmentFlow::PathNode source, ExecTaintedEnvironmentFlow::PathNode sink
where ExecTaintedEnvironmentFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command will be execute with a tainted $@.",
  sink.getNode(), "environment variable"
