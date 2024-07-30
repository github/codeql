private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.dataflow.FlowSteps
import codeql.actions.DataFlow
import codeql.actions.dataflow.FlowSources

abstract class EnvVarInjectionSink extends DataFlow::Node { }

/**
 * Holds if a Run step declares an environment variable with contents from a local file.
 * e.g.
 *    run: |
 *      echo "sha=$(cat test-results/sha-number)" >> $GITHUB_ENV
 *      echo "sha=$(<test-results/sha-number)" >> $GITHUB_ENV
 */
class EnvVarInjectionFromFileReadSink extends EnvVarInjectionSink {
  EnvVarInjectionFromFileReadSink() {
    exists(Run run, UntrustedArtifactDownloadStep step, string content, string value |
      this.asExpr() = run.getScriptScalar() and
      step.getAFollowingStep() = run and
      writeToGitHubEnv(run, content) and
      extractVariableAndValue(content, _, value) and
      (
        outputsPartialFileContent(value)
        or
        // e.g.
        // FOO=$(cat test-results/sha-number)
        // echo "FOO=$FOO" >> $GITHUB_ENV
        exists(string line, string var_name, string var_value |
          run.getScript().splitAt("\n") = line
        |
          var_name = line.regexpCapture("([a-zA-Z0-9\\-_]+)=(.*)", 1) and
          var_value = line.regexpCapture("([a-zA-Z0-9\\-_]+)=(.*)", 2) and
          outputsPartialFileContent(var_value) and
          (
            value.matches("%$" + ["", "{", "ENV{"] + var_name + "%")
            or
            value.regexpMatch("\\$\\((echo|printf|write-output)\\s+.*") and
            value.indexOf(var_name) > 0
          )
        )
      )
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
    exists(Run run, string var_name |
      envToSpecialFile("GITHUB_ENV", var_name, run, _) and
      exists(run.getInScopeEnvVarExpr(var_name)) and
      run.getScriptScalar() = this.asExpr()
    )
  }
}

/**
 * Holds if a 3rd party action declares an environment variable with contents from an untrusted file.
 * e.g.
 *- name: Load .env file
 *  uses: aarcangeli/load-dotenv@v1.0.0
 *  with:
 *    path: 'backend/new'
 *    filenames: |
 *      .env
 *      .env.test
 *    quiet: false
 *    if-file-not-found: error
 */
class EnvVarInjectionFromMaDSink extends EnvVarInjectionSink {
  EnvVarInjectionFromMaDSink() { madSink(this, "envvar-injection") }
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
