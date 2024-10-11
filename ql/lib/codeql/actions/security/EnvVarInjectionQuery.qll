private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.security.UntrustedCheckoutQuery
private import codeql.actions.dataflow.FlowSteps
import codeql.actions.DataFlow
import codeql.actions.dataflow.FlowSources

abstract class EnvVarInjectionSink extends DataFlow::Node { }

/**
 * Holds if a Run step declares an environment variable with contents from a local file.
 * e.g.
 *    run: |
 *      cat test-results/.env >> $GITHUB_ENV
 *
 *      echo "sha=$(cat test-results/sha-number)" >> $GITHUB_ENV
 *      echo "sha=$(<test-results/sha-number)" >> $GITHUB_ENV
 *
 *      FOO=$(cat test-results/sha-number)
 *      echo "FOO=$FOO" >> $GITHUB_ENV
 */
class EnvVarInjectionFromFileReadSink extends EnvVarInjectionSink {
  EnvVarInjectionFromFileReadSink() {
    exists(Run run, Step step |
      (
        step instanceof UntrustedArtifactDownloadStep or
        step instanceof PRHeadCheckoutStep
      ) and
      this.asExpr() = run.getScriptScalar() and
      step.getAFollowingStep() = run and
      (
        exists(string cmd |
          Bash::cmdReachingGitHubFileWrite(run, cmd, "GITHUB_ENV", _) and
          Bash::outputsPartialFileContent(run, cmd)
        )
        or
        Bash::fileToGitHubEnv(run, _)
      )
    )
  }
}

/**
 * Holds if a Run step executes a command that returns untrusted data which flows to GITHUB_ENV
 * e.g.
 *    run: |
 *          COMMIT_MESSAGE=$(git log --format=%s)
 *          echo "COMMIT_MESSAGE=${COMMIT_MESSAGE}" >> $GITHUB_ENV
 */
class EnvVarInjectionFromCommandSink extends EnvVarInjectionSink {
  EnvVarInjectionFromCommandSink() {
    exists(CommandSource source |
      this.asExpr() = source.getEnclosingRun().getScriptScalar() and
      Bash::cmdReachingGitHubFileWrite(source.getEnclosingRun(), source.getCommand(), "GITHUB_ENV",
        _)
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
      exists(run.getInScopeEnvVarExpr(var_name)) and
      run.getScriptScalar() = this.asExpr() and
      Bash::envReachingGitHubFileWrite(run, var_name, "GITHUB_ENV", _)
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

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run, string var |
      run.getInScopeEnvVarExpr(var) = pred.asExpr() and
      succ.asExpr() = run.getScriptScalar() and
      Bash::envReachingGitHubFileWrite(run, var, ["GITHUB_ENV", "GITHUB_OUTPUT", "GITHUB_PATH"], _)
    )
    or
    exists(Uses step |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = step and
      succ.asExpr() = step and
      madSink(succ, "envvar-injection")
    )
    or
    exists(Run run |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = run and
      succ.asExpr() = run.getScriptScalar() and
      Bash::outputsPartialFileContent(run, run.getACommand())
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate an environment variable. */
module EnvVarInjectionFlow = TaintTracking::Global<EnvVarInjectionConfig>;
