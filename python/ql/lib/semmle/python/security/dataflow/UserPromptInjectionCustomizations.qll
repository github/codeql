/**
 * Provides default sources, sinks and sanitizers for detecting
 * "user prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "user prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module UserPromptInjection {
  /**
   * A data flow source for "user prompt injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "user prompt injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "user prompt injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** An active threat-model source, considered as a flow source. */
  private class ActiveThreatModelSourceAsSource extends Source instanceof ActiveThreatModelSource {
  }

  /**
   * A prompt to an AI model, considered as a flow sink.
   */
  class AIPromptAsSink extends Sink {
    AIPromptAsSink() { this = any(AIPrompt p | p.isUserPrompt()).getAPrompt() }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }
}
