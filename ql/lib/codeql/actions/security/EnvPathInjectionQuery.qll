private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
private import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.DataFlow

predicate envPathInjectionFromExprSink(DataFlow::Node sink) {
  exists(Expression expr, Run run, string value |
    Utils::writeToGitHubPath(run, value) and
    expr = sink.asExpr() and
    run.getAnScriptExpr() = expr and
    value.indexOf(expr.getExpression()) > 0
  )
}

predicate envPathInjectionFromFileSink(DataFlow::Node sink) {
  exists(Run run, UntrustedArtifactDownloadStep step, string value |
    sink.asExpr() = run and
    step.getAFollowingStep() = run and
    Utils::writeToGitHubPath(run, value) and
    // TODO: add support for other commands like `<`, `jq`, ...
    value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
  )
}

/**
 * Holds if a Run step declares an environment variable, uses it to declare a PATH env var.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "$BODY" >> $GITHUB_PATH
 */
predicate envPathInjectionFromEnvSink(DataFlow::Node sink) {
  exists(Run run, Expression expr, string varname, string value |
    sink.asExpr().getInScopeEnvVarExpr(varname) = expr and
    run = sink.asExpr() and
    Utils::writeToGitHubPath(run, value) and
    (
      value = ["$" + varname, "${" + varname + "}", "$ENV{" + varname + "}"]
      or
      value.matches("$(echo %") and value.indexOf(varname) > 0
    )
  )
}

private class EnvPathInjectionSink extends DataFlow::Node {
  EnvPathInjectionSink() {
    envPathInjectionFromExprSink(this) or
    envPathInjectionFromFileSink(this) or
    envPathInjectionFromEnvSink(this) or
    externallyDefinedSink(this, "envpath-injection")
  }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate an environment variable.
 */
private module EnvPathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof EnvPathInjectionSink }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate the PATH environment variable. */
module EnvPathInjectionFlow = TaintTracking::Global<EnvPathInjectionConfig>;
