private import codeql.ruby.dataflow.FlowSummary

private class ReverseSummary extends SimpleSummarizedCallable {
  ReverseSummary() { this = "reverse" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].WithElement[any]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source
        .(DataFlow::PostUpdateNode)
        .getPreUpdateNode()
        .asExpr()
        .getExpr()
        .(MethodCall)
        .getMethodName() = "reverse"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall mc |
      mc.getMethodName() = "sink" and
      sink.asExpr().getExpr() = mc.getAnArgument()
    )
  }
}

/**
 * This predicate should not have a result. We check that the flow summary for
 * `reverse` does not get picked up by the `reverseStepThroughInputOutputAlias`
 * logic in `DataFlowImplCommon.qll`.
 */
query predicate noReverseStepThroughInputOutputAlias(DataFlow::Node source, DataFlow::Node sink) {
  DataFlow::Global<Config>::flow(source, sink)
}
