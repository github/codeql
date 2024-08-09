/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line is vulnerable to malicious
 *              changes in the strings.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id java/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import java
import semmle.code.java.security.CommandLineQuery
private import semmle.code.java.dataflow.DataFlowFiltering
private import semmle.code.java.dataflow.TaintTracking

module InputToArgumentToExecFlow =
  TaintTracking::Global<FilteredConfig<InputToArgumentToExecFlowConfig>>;

import InputToArgumentToExecFlow::PathGraph

predicate execIsTainted(
  InputToArgumentToExecFlow::PathNode source, InputToArgumentToExecFlow::PathNode sink, Expr execArg
) {
  InputToArgumentToExecFlow::flowPath(source, sink) and
  argumentToExec(execArg, sink.getNode())
}

from
  InputToArgumentToExecFlow::PathNode source, InputToArgumentToExecFlow::PathNode sink, Expr execArg
where execIsTainted(source, sink, execArg)
select execArg, source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value"
