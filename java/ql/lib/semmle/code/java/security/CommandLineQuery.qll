/**
 * Provides classes and methods common to queries `java/command-line-injection`, `java/command-line-concatenation`
 * and their experimental derivatives.
 *
 * Do not import this from a library file, in order to reduce the risk of
 * unintentionally bringing a TaintTracking::Configuration into scope in an unrelated
 * query.
 */

import java
private import semmle.code.java.dataflow.FlowSources
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.CommandArguments
private import semmle.code.java.security.ExternalProcess
private import semmle.code.java.security.Sanitizers

/** A sink for command injection vulnerabilities. */
abstract class CommandInjectionSink extends DataFlow::Node { }

/** A sanitizer for command injection vulnerabilities. */
abstract class CommandInjectionSanitizer extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to configurations related to command injection.
 */
class CommandInjectionAdditionalTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for configurations related to command injection.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

private class DefaultCommandInjectionSink extends CommandInjectionSink {
  DefaultCommandInjectionSink() { sinkNode(this, "command-injection") }
}

private class DefaultCommandInjectionSanitizer extends CommandInjectionSanitizer {
  DefaultCommandInjectionSanitizer() {
    this instanceof SimpleTypeSanitizer
    or
    isSafeCommandArgument(this.asExpr())
  }
}

/**
 * A taint-tracking configuration for unvalidated user input that is used to run an external process.
 */
module InputToArgumentToExecFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CommandInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof CommandInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(CommandInjectionAdditionalTaintStep s).step(n1, n2)
  }

  // It's valid to use diff-informed data flow for this configuration because
  // the location of the selected element in the query is contained inside the
  // location of the sink. The query, as a predicate, is used negated in
  // another query, but that's only to prevent overlapping results between two
  // queries.
  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * DEPRECATED: Use `InputToArgumentToExecFlowConfig` instead.
 */
deprecated module RemoteUserInputToArgumentToExecFlowConfig = InputToArgumentToExecFlowConfig;

/**
 * Taint-tracking flow for unvalidated input that is used to run an external process.
 */
module InputToArgumentToExecFlow = TaintTracking::Global<InputToArgumentToExecFlowConfig>;

/**
 * DEPRECATED: Use `InputToArgumentToExecFlow` instead.
 */
deprecated module RemoteUserInputToArgumentToExecFlow = InputToArgumentToExecFlow;

/**
 * A taint-tracking configuration for unvalidated local user input that is used to run an external process.
 */
deprecated module LocalUserInputToArgumentToExecFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof LocalUserInput }

  predicate isSink(DataFlow::Node sink) { sink instanceof CommandInjectionSink }

  predicate isBarrier(DataFlow::Node node) { node instanceof CommandInjectionSanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    any(CommandInjectionAdditionalTaintStep s).step(n1, n2)
  }
}

/**
 * DEPRECATED: Use `InputToArgumentToExecFlow` instead and configure threat model sources to include `local`.
 *
 * Taint-tracking flow for unvalidated local user input that is used to run an external process.
 */
deprecated module LocalUserInputToArgumentToExecFlow =
  TaintTracking::Global<LocalUserInputToArgumentToExecFlowConfig>;

/**
 * Implementation of `ExecTainted.ql`. It is extracted to a QLL
 * so that it can be excluded from `ExecUnescaped.ql` to avoid
 * reporting overlapping results.
 */
predicate execIsTainted(
  InputToArgumentToExecFlow::PathNode source, InputToArgumentToExecFlow::PathNode sink, Expr execArg
) {
  InputToArgumentToExecFlow::flowPath(source, sink) and
  argumentToExec(execArg, sink.getNode())
}
