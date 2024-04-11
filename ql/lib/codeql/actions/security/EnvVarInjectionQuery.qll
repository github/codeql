private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
private import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.DataFlow

predicate envVarInjectionFromExprSink(DataFlow::Node sink) {
  exists(Expression expr, Run run, string key, string value |
    Utils::writeToGitHubEnv(run, key, value) and
    expr = sink.asExpr() and
    run.getAnScriptExpr() = expr and
    value.indexOf(expr.getRawExpression()) > 0
  )
}

predicate envVarInjectionFromFileSink(DataFlow::Node sink) {
  exists(Run run, ArtifactDownloadStep step, string value |
    sink.asExpr() = run and
    step.getAFollowingStep() = run and
    Utils::writeToGitHubEnv(run, _, value) and
    // TODO: add support for other commands like `<`, `jq`, ...
    value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
  )
}

/**
 * Holds if a Run step declares an environment variable, uses it to declare a new env var.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "foo=$(echo $BODY)" >> $GITHUB_ENV
 */
predicate envVarInjectionFromEnvSink(DataFlow::Node sink) {
  exists(Run run, Expression expr, string varName, string value |
    sink.asExpr().getInScopeEnvVarExpr(varName) = expr and
    run = sink.asExpr() and
    Utils::writeToGitHubEnv(run, _, value) and
    value.indexOf("$" + ["", "{", "ENV{"] + varName) > 0
  )
}

private class EnvVarInjectionSink extends DataFlow::Node {
  EnvVarInjectionSink() {
    envVarInjectionFromExprSink(this) or
    envVarInjectionFromFileSink(this) or
    envVarInjectionFromEnvSink(this) or
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
