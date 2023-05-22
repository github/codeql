/**
 * @name Local-user-controlled command line
 * @description Using externally controlled strings in a command line is vulnerable to malicious
 *              changes in the strings.
 * @kind path-problem
 * @problem.severity recommendation
 * @security-severity 9.8
 * @precision medium
 * @id java/command-line-injection-local
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import java
import semmle.code.java.security.CommandLineQuery
import LocalUserInputToArgumentToExecFlow::PathGraph

from
  LocalUserInputToArgumentToExecFlow::PathNode source,
  LocalUserInputToArgumentToExecFlow::PathNode sink
where LocalUserInputToArgumentToExecFlow::flowPath(source, sink)
select sink.getNode().asExpr(), source, sink, "This command line depends on a $@.",
  source.getNode(), "user-provided value"
