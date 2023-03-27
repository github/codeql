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

module LocalUserInputToArgumentToExecFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToExec }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
    or
    isSafeCommandArgument(node.asExpr())
  }
}

module LocalUserInputToArgumentToExecFlow =
  TaintTracking::Global<LocalUserInputToArgumentToExecFlowConfig>;

import LocalUserInputToArgumentToExecFlow::PathGraph

from
  LocalUserInputToArgumentToExecFlow::PathNode source,
  LocalUserInputToArgumentToExecFlow::PathNode sink, ArgumentToExec execArg
where
  LocalUserInputToArgumentToExecFlow::flowPath(source, sink) and
  sink.getNode().asExpr() = execArg
select execArg, source, sink, "This command line depends on a $@.", source.getNode(),
  "user-provided value"
