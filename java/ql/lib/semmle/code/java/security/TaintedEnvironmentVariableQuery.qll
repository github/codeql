/** Modules to reason about the tainting of environment variables */

private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.Maps
private import semmle.code.java.JDK

private module ProcessBuilderEnvironmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(MethodCall mc | mc = source.asExpr() |
      mc.getMethod().hasQualifiedName("java.lang", "ProcessBuilder", "environment")
    )
  }

  predicate isSink(DataFlow::Node sink) { sink.asExpr() = any(MapPutCall mpc).getQualifier() }
}

private module ProcessBuilderEnvironmentFlow = DataFlow::Global<ProcessBuilderEnvironmentConfig>;

/**
 * A taint-tracking configuration that tracks flow from unvalidated data to an environment variable for a subprocess.
 */
module ExecTaintedEnvironmentConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sinkNode(sink, "environment-injection")
    or
    // sink is an added to a `ProcessBuilder::environment` map.
    exists(MapPutCall mpc | mpc.getAnArgument() = sink.asExpr() |
      ProcessBuilderEnvironmentFlow::flowToExpr(mpc.getQualifier())
    )
  }
}

/**
 * Taint-tracking flow for unvalidated data to an environment variable for a subprocess.
 */
module ExecTaintedEnvironmentFlow = TaintTracking::Global<ExecTaintedEnvironmentConfig>;
