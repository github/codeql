private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
private import codeql.actions.security.ControlChecks
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

  ArgumentInjectionFromEnvVarSink() {
    exists(Run run, string var |
      run.getScript() = this.asExpr() and
      (
        exists(run.getInScopeEnvVarExpr(var)) or
        var = "GITHUB_HEAD_REF"
      ) and
      run.getScript().getAnEnvReachingArgumentInjectionSink(var, command, _)
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
    exists(CommandSource source, Run run |
      run = source.getEnclosingRun() and
      this.asExpr() = run.getScript() and
      run.getScript().getACmdReachingArgumentInjectionSink(source.getCommand(), command, _)
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
 * Gets the event that is relevant for the given node in the context of argument injection.
 *
 * This is used to highlight the event in the query results when an alert is raised.
 */
Event getRelevantEventInPrivilegedContext(DataFlow::Node node) {
  inPrivilegedContext(node.asExpr(), result) and
  not exists(ControlCheck check | check.protects(node.asExpr(), result, "argument-injection"))
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

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSourceLocation(DataFlow::Node source) { none() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.getLocation()
    or
    result = getRelevantEventInPrivilegedContext(sink).getLocation()
  }
}

/** Tracks flow of unsafe user input that is used to construct and evaluate a code script. */
module ArgumentInjectionFlow = TaintTracking::Global<ArgumentInjectionConfig>;
