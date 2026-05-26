/**
 * Provides default sources, sinks and sanitizers for detecting
 * "prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import experimental.semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.frameworks.data.ModelsAsData
private import experimental.semmle.python.frameworks.OpenAI

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "prompt injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module PromptInjection {
  /**
   * A data flow source for "prompt injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "prompt injection" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for "prompt injection" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A prompt to an AI model, considered as a flow sink.
   */
  class AIPromptAsSink extends Sink {
    AIPromptAsSink() { this = any(AIPrompt p).getAPrompt() }
  }

  private class SinkFromModel extends Sink {
    SinkFromModel() { this = ModelOutput::getASinkNode("prompt-injection").asSink() }
  }

  private class PromptContentSink extends Sink {
    PromptContentSink() {
      this = OpenAI::getContentNode().asSink()
      or
      this = AgentSDK::getContentNode().asSink()
    }
  }

  /**
   * A comparison with a constant, considered as a sanitizer-guard.
   */
  class ConstCompareAsSanitizerGuard extends Sanitizer, ConstCompareBarrier { }
}
