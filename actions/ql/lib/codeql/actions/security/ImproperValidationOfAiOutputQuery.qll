/**
 * Provides classes and predicates for detecting improper validation of
 * generative AI output in GitHub Actions workflows (CWE-1426).
 *
 * This library identifies cases where AI-generated output flows unsanitized
 * into code execution sinks (LOTP gadgets) or subsequent AI prompts.
 */

private import actions
private import codeql.actions.TaintTracking
private import codeql.actions.dataflow.ExternalFlow
import codeql.actions.dataflow.FlowSources
import codeql.actions.DataFlow
import codeql.actions.security.ControlChecks

/**
 * A source representing AI-generated output from AI inference actions.
 * This models CWE-1426 where AI output is used without proper validation,
 * potentially allowing an attacker to chain prompt injection into code execution.
 */
class AiInferenceOutputSource extends DataFlow::Node {
  UsesStep aiStep;

  AiInferenceOutputSource() {
    exists(StepsExpression stepRef, string action |
      this.asExpr() = stepRef and
      stepRef.getStepId() = aiStep.getId() and
      actionsSinkModel(action, _, _, "ai-inference", _) and
      aiStep.getCallee() = action
    )
  }

  /** Gets the AI inference step that produces this output. */
  UsesStep getAiStep() { result = aiStep }
}

/**
 * A sink for improper validation of AI output (CWE-1426).
 * AI output flowing unsanitized to code execution (LOTP gadgets),
 * subsequent AI prompts, or environment manipulation.
 */
class ImproperAiOutputSink extends DataFlow::Node {
  ImproperAiOutputSink() {
    // Code injection sinks (run steps) -- LOTP gadgets
    exists(Run e | e.getAnScriptExpr() = this.asExpr())
    or
    // MaD-defined code injection sinks
    madSink(this, "code-injection")
    or
    // AI inference sinks (AI output flowing to another AI prompt = chained injection)
    madSink(this, "ai-inference")
  }
}

/**
 * Gets the relevant event for sinks in a privileged context.
 */
Event getRelevantEventForAiOutputSink(DataFlow::Node sink) {
  inPrivilegedContext(sink.asExpr(), result) and
  not exists(ControlCheck check | check.protects(sink.asExpr(), result, "code-injection"))
}

/**
 * Holds when a critical-severity AI output validation issue exists.
 */
predicate criticalAiOutputInjection(
  ImproperAiOutputFlow::PathNode source, ImproperAiOutputFlow::PathNode sink, Event event
) {
  ImproperAiOutputFlow::flowPath(source, sink) and
  event = getRelevantEventForAiOutputSink(sink.getNode())
}

/**
 * A taint-tracking configuration for AI-generated output
 * that flows unsanitized to code execution or subsequent AI prompts.
 */
private module ImproperAiOutputConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof AiInferenceOutputSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof ImproperAiOutputSink }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.getLocation()
    or
    result = getRelevantEventForAiOutputSink(sink).getLocation()
  }
}

/** Tracks flow of AI-generated output to code execution sinks. */
module ImproperAiOutputFlow = TaintTracking::Global<ImproperAiOutputConfig>;
