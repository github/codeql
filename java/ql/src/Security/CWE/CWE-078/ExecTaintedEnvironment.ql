/**
 * @name Building a command with an injected environment variable
 * @description Passing environment variables containing externally controlled
 *              strings to a command line is vulnerable to malicious changes to the
 *              environment of a subprocess.
 * @problem.severity error
 * @kind path-problem
 * @security-severity 9.8
 * @precision medium
 * @id java/exec-tainted-environment
 * @tags security
 *    external/cwe/cwe-078
 *    external/cwe/cwe-088
 *    external/cwe/cwe-454
 */

import java
import semmle.code.java.security.TaintedEnvironmentVariableQuery
import ExecTaintedEnvironmentFlow::PathGraph

from ExecTaintedEnvironmentFlow::PathNode source, ExecTaintedEnvironmentFlow::PathNode sink
where ExecTaintedEnvironmentFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This command will be execute with a tainted environment variable."
