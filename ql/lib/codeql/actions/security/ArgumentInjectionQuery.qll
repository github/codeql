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
 * Holds if an environment variable is used, directly or indirectly, as an argument to a dangerous command
 * in a Run step.
 * Where the command is a string captured from the Run's script.
 */
bindingset[var]
predicate envToArgInjSink(string var, Run run, string command) {
  exists(string argument, string cmd, string regexp, int command_group, int argument_group |
    run.getACommand() = cmd and
    argumentInjectionSinksDataModel(regexp, command_group, argument_group) and
    command = cmd.regexpCapture(regexp, command_group) and
    argument = cmd.regexpCapture(regexp, argument_group) and
    Bash::envReachingRunExpr(run, var, argument) and
    exists(run.getInScopeEnvVarExpr(var))
  )
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
    exists(Run run, string var |
      envToArgInjSink(var, run, command) and
      run.getScriptScalar() = this.asExpr() and
      exists(run.getInScopeEnvVarExpr(var))
    )
    or
    exists(
      Run run, string cmd, string argument, string regexp, int argument_group, int command_group
    |
      run.getACommand() = cmd and
      run.getScriptScalar() = this.asExpr() and
      argumentInjectionSinksDataModel(regexp, command_group, argument_group) and
      argument = cmd.regexpCapture(regexp, argument_group) and
      command = cmd.regexpCapture(regexp, command_group) and
      argument.regexpMatch(".*\\$(\\{)?(GITHUB_HEAD_REF).*")
    )
  }

  override string getCommand() { result = command }
}

/**
 * Holds if a Run step executes a command that returns untrusted data which flows to an unsafe argument
 * e.g.
 *    run: |
 *       BODY=$(git log --format=%s)
 *       sed "s/FOO/$BODY/g" > /tmp/foo
 */
class ArgumentInjectionFromCommandSink extends ArgumentInjectionSink {
  string command;

  ArgumentInjectionFromCommandSink() {
    exists(
      CommandSource source, Run run, string cmd, string argument, string regexp, int argument_group,
      int command_group
    |
      run = source.getEnclosingRun() and
      this.asExpr() = run.getScriptScalar() and
      cmd = run.getACommand() and
      argumentInjectionSinksDataModel(regexp, command_group, argument_group) and
      argument = cmd.regexpCapture(regexp, argument_group) and
      command = cmd.regexpCapture(regexp, command_group)
    )
  }

  override string getCommand() { result = command }
}

/**
 * Holds if a Run step declares an environment variable, uses it as the argument to a command vulnerable to argument injection.
 */
class ArgumentInjectionFromMaDSink extends ArgumentInjectionSink {
  ArgumentInjectionFromMaDSink() { madSink(this, "argument-injection") }

  override string getCommand() { result = "unknown" }
}

/**
 * A taint-tracking configuration for unsafe user input
 * that is used to construct and evaluate a code script.
 */
private module ArgumentInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    exists(
      Run run, string argument, string cmd, string regexp, int command_group, int argument_group
    |
      run.getScriptScalar() = source.asExpr() and
      run.getACommand() = cmd and
      argumentInjectionSinksDataModel(regexp, command_group, argument_group) and
      argument = cmd.regexpCapture(regexp, argument_group) and
      argument.regexpMatch(".*\\$(\\{)?(GITHUB_HEAD_REF).*")
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof ArgumentInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run, string var |
      run.getInScopeEnvVarExpr(var) = pred.asExpr() and
      succ.asExpr() = run.getScriptScalar() and
      envToArgInjSink(var, run, _)
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module ArgumentInjectionFlow = TaintTracking::Global<ArgumentInjectionConfig>;
