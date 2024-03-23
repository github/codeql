private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow

predicate writeToGithubEnvSink(DataFlow::Node sink) {
  exists(Expression expr, Run run, string script, string line, string value |
    script = run.getScript() and
    line = script.splitAt("\n") and
    value = line.regexpCapture("echo\\s+.*\\s*=(.*)>>\\s*\\$GITHUB_ENV", 1) and
    expr = sink.asExpr() and
    run.getAnScriptExpr() = expr and
    value.indexOf(expr.getRawExpression()) > 0
  )
}

private class EnvVarInjectionSink extends DataFlow::Node {
  EnvVarInjectionSink() {
    writeToGithubEnvSink(this) or
    externallyDefinedSink(this, "envvar-injection")
  }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate an environment variable.
 */
private module EnvVarInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof EnvVarInjectionSink }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate an environment variable. */
module EnvVarInjectionFlow = TaintTracking::Global<EnvVarInjectionConfig>;
