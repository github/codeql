private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.security.UntrustedCheckoutQuery

abstract class EnvPathInjectionSink extends DataFlow::Node { }

/**
 * Holds if a Run step declares a PATH environment variable with contents from a local file.
 */
class EnvPathInjectionFromFileReadSink extends EnvPathInjectionSink {
  EnvPathInjectionFromFileReadSink() {
    exists(Run run, Step step |
      (
        step instanceof UntrustedArtifactDownloadStep or
        step instanceof PRHeadCheckoutStep
      ) and
      this.asExpr() = run.getScript() and
      step.getAFollowingStep() = run and
      (
        // echo "$(cat foo.txt)" >> $GITHUB_PATH
        // FOO=$(cat foo.txt)
        // echo "$FOO" >> $GITHUB_PATH
        exists(string cmd |
          run.getScript().getAFileReadCommand() = cmd and
          run.getScript().getACmdReachingGitHubPathWrite(cmd)
        )
        or
        // cat foo.txt >> $GITHUB_PATH
        run.getScript().fileToGitHubPath(_)
      )
    )
  }
}

/**
 * Holds if a Run step executes a command that returns untrusted data which flows to GITHUB_ENV
 * e.g.
 *    run: |
 *          COMMIT_MESSAGE=$(git log --format=%s)
 *          echo "${COMMIT_MESSAGE}" >> $GITHUB_PATH
 */
class EnvPathInjectionFromCommandSink extends EnvPathInjectionSink {
  EnvPathInjectionFromCommandSink() {
    exists(CommandSource source |
      this.asExpr() = source.getEnclosingRun().getScript() and
      source.getEnclosingRun().getScript().getACmdReachingGitHubPathWrite(source.getCommand())
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
    exists(Run run, string var_name |
      run.getScript().getAnEnvReachingGitHubPathWrite(var_name) and
      exists(run.getInScopeEnvVarExpr(var_name)) and
      run.getScript() = this.asExpr()
    )
  }
}

class EnvPathInjectionFromMaDSink extends EnvPathInjectionSink {
  EnvPathInjectionFromMaDSink() { madSink(this, "envpath-injection") }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate an environment variable.
 */
private module EnvPathInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof EnvPathInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run, string var |
      run.getInScopeEnvVarExpr(var) = pred.asExpr() and
      succ.asExpr() = run.getScript() and
      (
        run.getScript().getAnEnvReachingGitHubEnvWrite(var, _)
        or
        run.getScript().getAnEnvReachingGitHubOutputWrite(var, _)
        or
        run.getScript().getAnEnvReachingGitHubPathWrite(var)
      )
    )
    or
    exists(Uses step |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = step and
      succ.asExpr() = step and
      madSink(succ, "envpath-injection")
    )
    or
    exists(Run run |
      pred instanceof FileSource and
      pred.asExpr().(Step).getAFollowingStep() = run and
      succ.asExpr() = run.getScript() and
      exists(run.getScript().getAFileReadCommand())
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate the PATH environment variable. */
module EnvPathInjectionFlow = TaintTracking::Global<EnvPathInjectionConfig>;
