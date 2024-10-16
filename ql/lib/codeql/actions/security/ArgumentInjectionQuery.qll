private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow

abstract class ArgumentInjectionSink extends DataFlow::Node {
  abstract string getCommand();
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
  string argument;

  ArgumentInjectionFromEnvVarSink() {
    exists(Run run, string var |
      run.getScript() = this.asExpr() and
      (
        exists(run.getInScopeEnvVarExpr(var)) or
        var = "GITHUB_HEAD_REF"
      ) and
      run.getScript().getAnEnvReachingArgumentInjectionSink(var, command, argument)
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
  string argument;

  ArgumentInjectionFromCommandSink() {
    exists(CommandSource source, Run run |
      run = source.getEnclosingRun() and
      this.asExpr() = run.getScript() and
      run.getScript().getACmdReachingArgumentInjectionSink(source.getCommand(), command, argument)
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
    exists(Run run |
      run.getScript() = source.asExpr() and
      run.getScript().getAnEnvReachingArgumentInjectionSink("GITHUB_HEAD_REF", _, _)
    )
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof ArgumentInjectionSink }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(Run run, string var |
      run.getInScopeEnvVarExpr(var) = pred.asExpr() and
      succ.asExpr() = run.getScript() and
      run.getScript().getAnEnvReachingArgumentInjectionSink(var, _, _)
    )
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module ArgumentInjectionFlow = TaintTracking::Global<ArgumentInjectionConfig>;
