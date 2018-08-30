/**
 * @name Local-user-controlled command line
 * @description Using externally controlled strings in a command line is vulnerable to malicious
 *              changes in the strings.
 * @kind problem
 * @problem.severity recommendation
 * @precision medium
 * @id java/command-line-injection-local
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ExternalProcess

class LocalUserInputToArgumentToExecFlowConfig extends TaintTracking::Configuration {
  LocalUserInputToArgumentToExecFlowConfig() { this = "LocalUserInputToArgumentToExecFlowConfig" }
  override predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }
  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToExec }
  override predicate isSanitizer(DataFlow::Node node) { node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType }
}

from StringArgumentToExec execArg, LocalUserInput origin, LocalUserInputToArgumentToExecFlowConfig conf
where conf.hasFlow(origin, DataFlow::exprNode(execArg))
select execArg, "$@ flows to here and is used in a command.", origin, "User-provided value"
