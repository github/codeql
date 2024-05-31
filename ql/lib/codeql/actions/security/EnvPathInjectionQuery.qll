private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
private import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.DataFlow

abstract class EnvPathInjectionSink extends DataFlow::Node { }

class EnvPathInjectionFromFileReadSink extends EnvPathInjectionSink {
  EnvPathInjectionFromFileReadSink() {
    exists(Run run, UntrustedArtifactDownloadStep step, string value |
      this.asExpr() = run.getScriptScalar() and
      step.getAFollowingStep() = run and
      writeToGitHubPath(run, value) and
      // TODO: add support for other commands like `<`, `jq`, ...
      value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
    )
  }
}

/**
 * Holds if a Run step declares an environment variable, uses it to declare a PATH env var.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "$BODY" >> $GITHUB_PATH
 */
class EnvPathInjectionFromEnvVarSink extends EnvPathInjectionSink {
  EnvPathInjectionFromEnvVarSink() {
    exists(Run run, Expression expr, string var_name, string value |
      this.asExpr().getInScopeEnvVarExpr(var_name) = expr and
      run.getScriptScalar() = this.asExpr() and
      writeToGitHubPath(run, value) and
      (
        value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
        or
        value.matches("$(echo %") and value.indexOf(var_name) > 0
      )
    )
  }
}

class EnvPathInjectionFromMaDSink extends EnvPathInjectionSink {
  EnvPathInjectionFromMaDSink() { externallyDefinedSink(this, "envpath-injection") }
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
