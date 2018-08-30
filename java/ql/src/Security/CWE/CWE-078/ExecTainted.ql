/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line is vulnerable to malicious
 *              changes in the strings.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ExternalProcess
import ExecCommon

from StringArgumentToExec execArg, RemoteUserInput origin
where execTainted(origin, execArg)
select execArg, "$@ flows to here and is used in a command.", origin, "User-provided value"
