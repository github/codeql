private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
private import codeql.actions.security.ArtifactPoisoningQuery
import codeql.actions.DataFlow

abstract class EnvVarInjectionSink extends DataFlow::Node { }

class EnvVarInjectionFromEnvVarSink extends EnvVarInjectionSink {
  EnvVarInjectionFromEnvVarSink() {
    exists(Run run, Expression expr, string var_name, string content, string value |
      expr = run.getInScopeEnvVarExpr(var_name) and
      writeToGitHubEnv(run, content) and
      extractVariableAndValue(content, _, value) and
      run.getScriptScalar() = this.asExpr() and
      value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
    )
  }
}

class EnvVarInjectionFromFileReadSink extends EnvVarInjectionSink {
  EnvVarInjectionFromFileReadSink() {
    exists(Run run, UntrustedArtifactDownloadStep step, string content, string value |
      this.asExpr() = run.getScriptScalar() and
      step.getAFollowingStep() = run and
      writeToGitHubEnv(run, content) and
      extractVariableAndValue(content, _, value) and
      // TODO: add support for other commands like `<`, `jq`, ...
      value.regexpMatch(["\\$\\(", "`"] + ["cat\\s+", "<"] + ".*" + ["`", "\\)"])
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
