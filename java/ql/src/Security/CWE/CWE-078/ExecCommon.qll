import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.ExternalProcess

private class RemoteUserInputToArgumentToExecFlowConfig extends TaintTracking::Configuration {
  RemoteUserInputToArgumentToExecFlowConfig() { this = "ExecCommon::RemoteUserInputToArgumentToExecFlowConfig" }
  override predicate isSource(DataFlow::Node src) { src instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) { sink.asExpr() instanceof ArgumentToExec }
  override predicate isSanitizer(DataFlow::Node node) { node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType }
}

/**
 * Implementation of `ExecTainted.ql`. It is extracted to a QLL
 * so that it can be excluded from `ExecUnescaped.ql` to avoid
 * reporting overlapping results.
 */
predicate execTainted(RemoteUserInput source, ArgumentToExec execArg) {
  exists(RemoteUserInputToArgumentToExecFlowConfig conf |
    conf.hasFlow(source, DataFlow::exprNode(execArg))
  )
}
