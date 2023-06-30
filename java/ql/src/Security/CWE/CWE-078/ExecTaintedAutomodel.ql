/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line is vulnerable to malicious
 *              changes in the strings.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/command-line-injection-automodel
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 *       ai-generated
 */

import java
import semmle.code.java.security.CommandLineQuery
import RemoteUserInputToArgumentToExecFlow::PathGraph
private import semmle.code.java.AutomodelSinkTriageUtils

from
  RemoteUserInputToArgumentToExecFlow::PathNode source,
  RemoteUserInputToArgumentToExecFlow::PathNode sink, Expr execArg
where execIsTainted(source, sink, execArg)
select execArg, source, sink,
  "This command line depends on a $@." + getSinkModelQueryRepr(sink.getNode().asExpr()),
  source.getNode(), "user-provided value"
