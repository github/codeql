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
 * A taint-tracking configuration for unvalidated user input that is used to run an external process.
 */
class RemoteUserInputToArgumentToExecFlowConfig extends TaintTracking::Configuration {
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
 * Implementation of `ExecTainted.ql`. It is extracted to a QLL
 * so that it can be excluded from `ExecUnescaped.ql` to avoid
 * reporting overlapping results.
 */
predicate execTainted(DataFlow::PathNode source, DataFlow::PathNode sink, ArgumentToExec execArg) {
  exists(RemoteUserInputToArgumentToExecFlowConfig conf |
    conf.hasFlowPath(source, sink) and sink.getNode() = DataFlow::exprNode(execArg)
  )
}
