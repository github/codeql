/** Modules to reason about the tainting of environment variables */

private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.Maps
private import semmle.code.java.JDK

private module ProcessBuilderEnvironmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.getType() instanceof TypeProcessBuilder }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodCall mc | mc.getQualifier() = node1.asExpr() and mc = node2.asExpr() |
      mc.getMethod().hasQualifiedName("java.lang", "ProcessBuilder", "environment")
    )
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(MapPutCall mpc).getQualifier() }
}

private module ProcessBuilderEnvironmentFlow =
  TaintTracking::Global<ProcessBuilderEnvironmentConfig>;

module ExecTaintedEnvironmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sinkNode(sink, "environment-injection")
    or
    exists(MapPutCall mpc | mpc.getAnArgument() = sink.asExpr() |
      ProcessBuilderEnvironmentFlow::flow(_, DataFlow::exprNode(mpc.getQualifier()))
    )
  }
}

module ExecTaintedEnvironmentFlow = TaintTracking::Global<ExecTaintedEnvironmentConfig>;
