private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.dataflow.FlowSteps
import codeql.actions.DataFlow

abstract class ArgumentInjectionSink extends DataFlow::Node {
  abstract string getCommand();
}

/**
 * Holds if a Run step declares an environment variable with contents from a local file.
 * e.g.
 *    run: |
 *      echo "sha=$(cat test-results/sha-number)" >> $GITHUB_ENV
 *      echo "sha=$(<test-results/sha-number)" >> $GITHUB_ENV
 *class ArgumentInjectionFromFileReadSink extends ArgumentInjectionSink {
 *  ArgumentInjectionFromFileReadSink() {
 *    exists(Run run, UntrustedArtifactDownloadStep step, string content, string value |
 *      this.asExpr() = run.getScriptScalar() and
 *      step.getAFollowingStep() = run and
 *      writeToGitHubEnv(run, content) and
 *      extractVariableAndValue(content, _, value) and
 *      outputsPartialFileContent(value)
 *    )
 *  }
 *}
 */
predicate argumentInjectionSinks(string regexp, int command_group, int argument_group) {
  regexp = ".*(sed) (.*)" and command_group = 1 and argument_group = 2
}

/**
 * Holds if a Run step declares an environment variable, uses it as the argument to a command vulnerable to argument injection.
 * e.g.
 *    env:
 *      BODY: ${{ github.event.comment.body }}
 *    run: |
 *       sed "s/FOO/$BODY/g" > /tmp/foo
 */
class ArgumentInjectionFromEnvVarSink extends ArgumentInjectionSink {
  string command;

  ArgumentInjectionFromEnvVarSink() {
    exists(Run run, string var_name |
      envToArgInjSink(var_name, run, command) and
      exists(run.getInScopeEnvVarExpr(var_name)) and
      run.getScriptScalar() = this.asExpr()
    )
  }

  override string getCommand() { result = command }
}

class ArgumentInjectionFromMaDSink extends ArgumentInjectionSink {
  ArgumentInjectionFromMaDSink() { externallyDefinedSink(this, "argument-injection") }

  override string getCommand() { result = "unknown" }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a code script.
 */
private module ArgumentInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ArgumentInjectionSink }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module ArgumentInjectionFlow = TaintTracking::Global<ArgumentInjectionConfig>;
