/**
 * Provides classes and methods common to queries `java/command-line-injection`, `java/command-line-concatenation`
 * and their experimental derivatives.
 *
 * Do not import this from a library file, in order to reduce the risk of
 * unintentionally bringing a TaintTracking::Configuration into scope in an unrelated
 * query.
 */

import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ExternalProcess
import semmle.code.java.security.CommandArguments

/**
 * DEPRECATED: Use `RemoteUserInputToArgumentToExecFlow` instead.
 *
 * A taint-tracking configuration for unvalidated user input that is used to run an external process.
 */
deprecated class RemoteUserInputToArgumentToExecFlowConfig extends TaintTracking::Configuration {
  RemoteUserInputToArgumentToExecFlowConfig() {
    this = "ExecCommon::RemoteUserInputToArgumentToExecFlowConfig"
  }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToExec }

  override predicate isSanitizer(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
    or
    isSafeCommandArgument(node.asExpr())
  }
}

/**
 * A taint-tracking configuration for unvalidated user input that is used to run an external process.
 */
module RemoteUserInputToArgumentToExecFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToExec }

  predicate isBarrier(DataFlow::Node node) {
    node.getType() instanceof PrimitiveType
    or
    node.getType() instanceof BoxedType
    or
    isSafeCommandArgument(node.asExpr())
  }
}

module RemoteUserInputToArgumentToExecFlow =
  TaintTracking::Make<RemoteUserInputToArgumentToExecFlowConfig>;

/**
 * Implementation of `ExecTainted.ql`. It is extracted to a QLL
 * so that it can be excluded from `ExecUnescaped.ql` to avoid
 * reporting overlapping results.
 */
predicate execTainted(
  RemoteUserInputToArgumentToExecFlow::PathNode source,
  RemoteUserInputToArgumentToExecFlow::PathNode sink, ArgumentToExec execArg
) {
  RemoteUserInputToArgumentToExecFlow::hasFlowPath(source, sink) and
  sink.getNode() = DataFlow::exprNode(execArg)
}
