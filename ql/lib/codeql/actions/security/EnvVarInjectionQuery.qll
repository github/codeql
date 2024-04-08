private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
private import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.DataFlow

class EnvVarInjectionFromExprSink extends DataFlow::Node {
  EnvVarInjectionFromExprSink() {
    exists(Expression expr, Run run, string script, string line, string key, string value |
      script = run.getScript() and
      line = script.splitAt("\n") and
      Utils::extractAssignment(line, "ENV", key, value) and
      expr = this.asExpr() and
      run.getAnScriptExpr() = expr and
      value.indexOf(expr.getRawExpression()) > 0
    )
  }
}

class EnvVarInjectionFromFileSink extends DataFlow::Node {
  EnvVarInjectionFromFileSink() {
    exists(Run run, ArtifactDownloadStep step, string value |
      this.asExpr() = run and
      step.getAFollowingStep() = run and
      Utils::writeToGitHubEnv(run, _, value) and
      // TODO: add support for other commands like `<`, `jq`, ...
      value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
    )
  }
}

private class EnvVarInjectionSink extends DataFlow::Node {
  EnvVarInjectionSink() {
    this instanceof EnvVarInjectionFromExprSink or
    this instanceof EnvVarInjectionFromFileSink or
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
