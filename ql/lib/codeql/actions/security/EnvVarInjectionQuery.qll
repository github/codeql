private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
private import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.DataFlow

abstract class EnvVarInjectionSink extends DataFlow::Node { }

class EnvVarInjectionFromFileReadSink extends EnvVarInjectionSink {
  EnvVarInjectionFromFileReadSink() {
    exists(Run run, UntrustedArtifactDownloadStep step, string content, string value |
      this.asExpr() = run.getScriptScalar() and
      step.getAFollowingStep() = run and
      writeToGitHubEnv(run, content) and
      extractVariableAndValue(content, _, value) and
      // (eg: echo DATABASE_SHA=`yq '.creationMetadata.sha' codeql-database.yml` >> $GITHUB_ENV)
      value
          .regexpMatch(["\\$\\(", "`"] +
              ["cat\\s+", "<", "jq\\s+", "yq\\s+", "tail\\s+", "head\\s+"] + ".*" + ["`", "\\)"])
    )
  }
}

/**
 * Holds if a Run step declares an environment variable, uses it to declare env var.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *      echo "FOO=$BODY" >> $GITHUB_ENV
 */
class EnvVarInjectionFromEnvVarSink extends EnvVarInjectionSink {
  EnvVarInjectionFromEnvVarSink() {
    exists(Run run, Expression expr, string var_name, string content, string value |
      run.getInScopeEnvVarExpr(var_name) = expr and
      run.getScriptScalar() = this.asExpr() and
      writeToGitHubEnv(run, content) and
      extractVariableAndValue(content, _, value) and
      (
        value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
        or
        value.matches("$(echo %") and value.indexOf(var_name) > 0
      )
    )
  }
}

class EnvVarInjectionFromMaDSink extends EnvVarInjectionSink {
  EnvVarInjectionFromMaDSink() { externallyDefinedSink(this, "envvar-injection") }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate an environment variable.
 */
private module EnvVarInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not source.(RemoteFlowSource).getSourceType() = "branch"
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof EnvVarInjectionSink }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate an environment variable. */
module EnvVarInjectionFlow = TaintTracking::Global<EnvVarInjectionConfig>;
