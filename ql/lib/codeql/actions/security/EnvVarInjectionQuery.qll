private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ArtifactPoisoningQuery
private import codeql.actions.security.UntrustedCheckoutQuery

abstract class EnvVarInjectionSink extends DataFlow::Node { }

string sanitizerCommand() {
  result =
    [
      "tr\\s+(-d\\s*)?('|\")?.n('|\")?", // tr -d '\n' ' ', tr '\n' ' '
      "tr\\s+-cd\\s+.*:al(pha|num):", // tr -cd '[:alpha:_]'
      "(head|tail)\\s+-n\\s+1" // head -n 1, tail -n 1
    ]
}

/**
 * Holds if a Run step declares an environment variable with contents from a local file.
 */
class EnvVarInjectionFromFileReadSink extends EnvVarInjectionSink {
  EnvVarInjectionFromFileReadSink() {
    exists(Run run, Step step |
      (
        step instanceof UntrustedArtifactDownloadStep or
        step instanceof PRHeadCheckoutStep
      ) and
      this.asExpr() = run.getScript() and
      step.getAFollowingStep() = run and
      (
        // eg:
        // echo "SHA=$(cat test-results/sha-number)" >> $GITHUB_ENV
        // echo "SHA=$(<test-results/sha-number)" >> $GITHUB_ENV
        // FOO=$(cat test-results/sha-number)
        // echo "FOO=$FOO" >> $GITHUB_ENV
        exists(string cmd, string var, string sanitizer |
          run.getScript().getAFileReadCommand() = cmd and
          run.getScript().getACmdReachingGitHubEnvWrite(cmd, var) and
          run.getScript().getACmdReachingGitHubEnvWrite(sanitizer, var) and
          not exists(sanitizer.regexpFind(sanitizerCommand(), _, _))
        )
        or
        // eg: cat test-results/.env >> $GITHUB_ENV
        run.getScript().fileToGitHubEnv(_)
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
  CommandSource inCommand;
  string injectedVar;
  string command;

  EnvVarInjectionFromCommandSink() {
    exists(Run run |
      this.asExpr() = inCommand.getEnclosingRun().getScript() and
      run = inCommand.getEnclosingRun() and
      run.getScript().getACmdReachingGitHubEnvWrite(inCommand.getCommand(), injectedVar) and
      (
        // the source flows to the injected variable without any command in between
        not run.getScript().getACmdReachingGitHubEnvWrite(_, injectedVar) and
        command = ""
        or
        // the source flows to the injected variable with a command in between
        run.getScript().getACmdReachingGitHubEnvWrite(command, injectedVar) and
        not command.regexpMatch(".*" + sanitizerCommand() + ".*")
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
  string inVar;
  string injectedVar;
  string command;

  EnvVarInjectionFromEnvVarSink() {
    exists(Run run |
      run.getScript() = this.asExpr() and
      exists(run.getInScopeEnvVarExpr(inVar)) and
      run.getScript().getAnEnvReachingGitHubEnvWrite(inVar, injectedVar) and
      (
        // the source flows to the injected variable without any command in between
        not run.getScript().getACmdReachingGitHubEnvWrite(_, injectedVar) and
        command = ""
        or
        // the source flows to the injected variable with a command in between
        run.getScript().getACmdReachingGitHubEnvWrite(_, injectedVar) and
        run.getScript().getACmdReachingGitHubEnvWrite(command, injectedVar) and
        not command.regexpMatch(".*" + sanitizerCommand() + ".*")
      )
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
    not source.(RemoteFlowSource).getSourceType() = ["branch", "username"]
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof EnvVarInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run, string var |
      run.getInScopeEnvVarExpr(var) = pred.asExpr() and
      succ.asExpr() = run.getScript() and
      (
        run.getScript().getAnEnvReachingGitHubEnvWrite(var, _)
        or
        run.getScript().getAnEnvReachingGitHubOutputWrite(var, _)
      )
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
      succ.asExpr() = run.getScript() and
      exists(run.getScript().getAFileReadCommand())
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate an environment variable. */
module EnvVarInjectionFlow = TaintTracking::Global<EnvVarInjectionConfig>;
