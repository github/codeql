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

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ExternalProcess
import semmle.code.java.security.CommandArguments
import DataFlow::PathGraph

class LocalUserInputToArgumentToExecFlowConfig extends TaintTracking::Configuration {
  LocalUserInputToArgumentToExecFlowConfig() { this = "LocalUserInputToArgumentToExecFlowConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToExec }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
    or
    isSafeCommandArgument(node.asExpr())
  }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, ArgumentToExec execArg,
  LocalUserInputToArgumentToExecFlowConfig conf
where conf.hasFlowPath(source, sink) and sink.getNode().asExpr() = execArg
select execArg, source, sink, "$@ flows to here and is used in a command.", source.getNode(),
  "User-provided value"
