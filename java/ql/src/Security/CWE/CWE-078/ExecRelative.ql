/**
 * @name Executing a command with a relative path
 * @description Executing a command with a relative path is vulnerable to
 *              malicious changes in the PATH environment variable.
 * @kind problem
 * @problem.severity warning
 * @security-severity 5.4
 * @precision medium
 * @id java/relative-path-command
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import semmle.code.java.Expr
import semmle.code.java.security.RelativePaths
import semmle.code.java.security.ExternalProcess

from ArgumentToExec argument, string command
where
  (
    relativePath(argument, command) or
    arrayStartingWithRelative(argument, command)
  ) and
  not shellBuiltin(command)
select argument, "Command with a relative path '" + command + "' is executed."
